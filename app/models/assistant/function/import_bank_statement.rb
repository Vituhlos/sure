require "csv"

class Assistant::Function::ImportBankStatement < Assistant::Function
  class << self
    def name
      "import_bank_statement"
    end

    def description
      <<~INSTRUCTIONS
        Use this to import transactions from a bank statement PDF that has already been uploaded.

        This function will:
        1. Extract transaction data from the PDF using AI
        2. Create a transaction import with the extracted data
        3. Return the import ID and extracted transactions for review

        The PDF must have already been uploaded via the PDF import feature.
        Only use this for PDFs that are identified as bank statements.

        Example:

        ```
        import_bank_statement({
          pdf_import_id: "abc123-def456",
          account_id: "xyz789"
        })
        ```

        If account_id is not provided, you should ask the user which account to import to.
      INSTRUCTIONS
    end
  end

  def strict_mode?
    false
  end

  def params_schema
    build_schema(
      required: [ "pdf_import_id" ],
      properties: {
        pdf_import_id: {
          type: "string",
          description: "The ID of the PDF import to extract transactions from"
        },
        account_id: {
          type: "string",
          description: "The ID of the account to import transactions into. If not provided, will return available accounts."
        }
      }
    )
  end

  def call(params = {})
    pdf_import = family.imports.find_by(id: params["pdf_import_id"], type: "PdfImport")

    unless pdf_import
      return {
        success: false,
        error: "PDF import not found",
        message: I18n.t("assistant.functions.import_bank_statement.not_found", id: params["pdf_import_id"])
      }
    end

    unless pdf_import.document_type == "bank_statement"
      return {
        success: false,
        error: "not_bank_statement",
        message: I18n.t("assistant.functions.import_bank_statement.not_bank_statement", type: pdf_import.document_type),
        available_actions: [ I18n.t("assistant.functions.import_bank_statement.use_different_pdf") ]
      }
    end

    # If no account specified, return available accounts
    if params["account_id"].blank?
      return {
        success: false,
        error: "account_required",
        message: I18n.t("assistant.functions.import_bank_statement.account_required"),
        available_accounts: family.accounts.visible.depository.map { |a| { id: a.id, name: a.name } }
      }
    end

    account = family.accounts.find_by(id: params["account_id"])
    unless account
      return {
        success: false,
        error: "account_not_found",
        message: I18n.t("assistant.functions.import_bank_statement.account_not_found"),
        available_accounts: family.accounts.visible.depository.map { |a| { id: a.id, name: a.name } }
      }
    end

    # Extract transactions from the PDF using the configured LLM provider.
    # Honors Setting.llm_provider (issue #2113) — Provider::Anthropic implements
    # extract_bank_statement (PR #1985).
    provider = Provider::Registry.preferred_llm_provider
    unless provider
      return {
        success: false,
        error: "provider_not_configured",
        message: I18n.t("assistant.functions.import_bank_statement.provider_not_configured")
      }
    end

    response = provider.extract_bank_statement(
      pdf_content: pdf_import.pdf_file_content,
      model: openai_model,
      family: family
    )

    unless response.success?
      return {
        success: false,
        error: "extraction_failed",
        message: I18n.t("assistant.functions.import_bank_statement.extraction_failed")
      }
    end

    result = response.data

    if result[:transactions].blank?
      return {
        success: false,
        error: "no_transactions_found",
        message: I18n.t("assistant.functions.import_bank_statement.no_transactions")
      }
    end

    # Create a CSV from extracted transactions
    csv_content = generate_csv(result[:transactions])

    # Create a TransactionImport
    import = family.imports.create!(
      type: "TransactionImport",
      account: account,
      raw_file_str: csv_content,
      date_col_label: "date",
      amount_col_label: "amount",
      name_col_label: "name",
      category_col_label: "category",
      notes_col_label: "notes",
      date_format: "%Y-%m-%d",
      signage_convention: "inflows_positive"
    )

    import.generate_rows_from_csv

    {
      success: true,
      import_id: import.id,
      transaction_count: result[:transactions].size,
      transactions_preview: result[:transactions].first(5),
      statement_period: result[:period],
      account_holder: result[:account_holder],
      message: I18n.t(
        "assistant.functions.import_bank_statement.created",
        count: result[:transactions].size,
        id: import.id
      )
    }
  rescue Provider::Error, Faraday::Error, Timeout::Error, RuntimeError => e
    Rails.logger.error("ImportBankStatement error: #{e.class.name} - #{e.message}")
    Rails.logger.error(e.backtrace.first(10).join("\n"))
    {
      success: false,
      error: "extraction_failed",
      message: I18n.t("assistant.functions.import_bank_statement.extraction_failed")
    }
  end

  private

    def generate_csv(transactions)
      CSV.generate do |csv|
        csv << %w[date amount name category notes]
        transactions.each do |txn|
          csv << [
            txn[:date],
            txn[:amount],
            txn[:name] || txn[:description],
            txn[:category],
            txn[:notes]
          ]
        end
      end
    end

    def openai_model
      ENV["OPENAI_MODEL"].presence || Provider::Openai::DEFAULT_MODEL
    end
end
