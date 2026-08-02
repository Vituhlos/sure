class Assistant::Function::UpdateTransaction < Assistant::Function
  class << self
    def name
      "update_transaction"
    end

    def description
      <<~INSTRUCTIONS
        Updates an existing transaction.

        Use get_transactions first to find the transaction id, and get_categories,
        get_tags, or the current transaction merchant before referencing related ids.

        This tool can update the transaction name, notes, category, merchant, and
        tags. It will not edit split child transactions directly.
      INSTRUCTIONS
    end
  end

  def strict_mode?
    false
  end

  def params_schema
    build_schema(
      required: [ "id" ],
      properties: {
        id: {
          type: "string",
          description: "Transaction ID from get_transactions"
        },
        name: {
          type: "string",
          description: "New transaction name. Omit to leave unchanged."
        },
        notes: {
          type: [ "string", "null" ],
          description: "New transaction notes. Use null to clear notes. Omit to leave unchanged."
        },
        category_id: {
          type: [ "string", "null" ],
          description: "Category ID from get_categories. Use null to clear category. Omit to leave unchanged."
        },
        merchant_id: {
          type: [ "string", "null" ],
          description: "Merchant ID currently available to the family. Use null to clear merchant. Omit to leave unchanged."
        },
        tag_ids: {
          type: "array",
          items: { type: "string" },
          description: "Full list of tag IDs to set. Use an empty array to clear all tags. Omit to leave unchanged."
        }
      }
    )
  end

  def call(params = {})
    transaction = find_transaction(params["id"])
    return error("not_found", I18n.t("assistant.functions.update_transaction.not_found", id: params["id"])) unless transaction

    entry = transaction.entry
    return error("split_child", I18n.t("assistant.functions.update_transaction.split_child")) if entry.split_child?
    return error("not_authorized", I18n.t("assistant.functions.update_transaction.not_authorized")) unless permitted_to_update?(entry.account, params)

    entry_attrs = entry_attributes(params, entry)
    return entry_attrs if error_response?(entry_attrs)

    tag_ids = nil
    if params.key?("tag_ids")
      tag_ids = Array(params["tag_ids"]).map(&:to_s).reject(&:blank?)
      return error("invalid_tags", I18n.t("assistant.functions.update_transaction.invalid_tags")) unless valid_tag_ids?(tag_ids)
    end

    return error("no_changes", I18n.t("assistant.functions.update_transaction.no_changes")) if no_changes?(entry_attrs, params)

    Entry.transaction do
      entry.update!(entry_attrs)

      if params.key?("tag_ids")
        transaction.tag_ids = tag_ids
        transaction.save!
        transaction.lock_attr!(:tag_ids)
      end

      entry.sync_account_later
      entry.lock_saved_attributes!
    end

    {
      success: true,
      transaction: serialize(transaction.reload),
      message: I18n.t("assistant.functions.update_transaction.updated", name: transaction.entry.name)
    }
  rescue ActiveRecord::RecordInvalid => e
    error("validation_failed", e.record.errors.full_messages.join("; "))
  end

  private
    def find_transaction(id)
      return nil unless valid_uuid?(id)

      family.transactions
        .joins(:entry)
        .where(entries: { account_id: user.accessible_accounts.visible.select(:id) })
        .find_by(id: id)
    end

    def permitted_to_update?(account, params)
      permission = account.permission_for(user)
      return true if permission.in?([ :owner, :full_control ])

      permission == :read_write && !params.key?("name")
    end

    def entry_attributes(params, entry)
      entryable_attrs = { id: entry.entryable_id }

      if params.key?("category_id")
        category_id = optional_uuid(params["category_id"])
        return category_id if error_response?(category_id)
        return error("invalid_category", I18n.t("assistant.functions.update_transaction.invalid_category")) if category_id && !family.categories.exists?(id: category_id)

        entryable_attrs[:category_id] = category_id
      end

      if params.key?("merchant_id")
        merchant_id = optional_uuid(params["merchant_id"])
        return merchant_id if error_response?(merchant_id)
        return error("invalid_merchant", I18n.t("assistant.functions.update_transaction.invalid_merchant")) if merchant_id && !available_merchants.exists?(id: merchant_id)

        entryable_attrs[:merchant_id] = merchant_id
      end

      attrs = {}
      attrs[:name] = params["name"].to_s.strip if params.key?("name")
      attrs[:notes] = params["notes"] if params.key?("notes")
      attrs[:entryable_attributes] = entryable_attrs if entryable_attrs.keys.size > 1
      attrs
    end

    def optional_uuid(value)
      return nil if value.nil? || value == ""
      return value.to_s if valid_uuid?(value)

      error("invalid_uuid", I18n.t("assistant.functions.update_transaction.invalid_uuid"))
    end

    def valid_tag_ids?(tag_ids)
      family.tags.where(id: tag_ids).count == tag_ids.uniq.size
    end

    def available_merchants
      family.available_merchants_for(user)
    end

    def no_changes?(entry_attrs, params)
      entry_attrs.empty? && !params.key?("tag_ids")
    end

    def serialize(transaction)
      entry = transaction.entry
      {
        id: transaction.id,
        name: entry.name,
        date: entry.date,
        notes: entry.notes,
        category: transaction.category && {
          id: transaction.category.id,
          name: transaction.category.name
        },
        merchant: transaction.merchant && {
          id: transaction.merchant.id,
          name: transaction.merchant.name
        },
        tags: transaction.tags.map { |tag| { id: tag.id, name: tag.name } }
      }
    end

    def error_response?(value)
      value.is_a?(Hash) && value[:success] == false
    end

    def error(key, message)
      { success: false, error: key, message: message }
    end
end
