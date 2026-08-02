class EnableBankingItem::Syncer
  include SyncStats::Collector

  attr_reader :enable_banking_item

  def initialize(enable_banking_item)
    @enable_banking_item = enable_banking_item
  end

  def perform_sync(sync)
    # An expired/missing session is an expected state that needs user action, not a
    # hard failure. Mark the connection requires_update and finish the sync
    # gracefully so the UI surfaces the "Reconnect" CTA instead of a red sync error.
    unless enable_banking_item.session_valid?
      update_status(sync, :session_expired)
      enable_banking_item.update!(status: :requires_update)
      collect_health_stats(sync, errors: nil)
      return
    end

    # Phase 1: Import data from Enable Banking API
    update_status(sync, :importing_accounts)
    import_result = enable_banking_item.import_latest_enable_banking_data

    unless import_result[:success]
      # A session-level auth failure detected mid-import flips the item to
      # requires_update — surface that as a graceful reconnect state, not a red
      # error. Transient/per-account failures leave status good and fall through
      # to a normal sync error that retries next time.
      if enable_banking_item.requires_update?
        update_status(sync, :reauthorization_required)
        collect_health_stats(sync, errors: nil)
        return
      end

      error_msg = import_result[:error]
      if error_msg.blank? && (import_result[:accounts_failed].to_i > 0 || import_result[:transactions_failed].to_i > 0)
        parts = []
        parts << I18n.t("enable_banking_items.syncer.accounts_failed", count: import_result[:accounts_failed]) if import_result[:accounts_failed].to_i > 0
        parts << I18n.t("enable_banking_items.syncer.transactions_failed", count: import_result[:transactions_failed]) if import_result[:transactions_failed].to_i > 0
        error_msg = parts.join(", ")
      end
      raise StandardError.new(error_msg.presence || I18n.t("enable_banking_items.syncer.import_failed"))
    end

    # Phase 2: Check account setup status and collect sync statistics
    update_status(sync, :checking_account_configuration)
    collect_setup_stats(sync, provider_accounts: enable_banking_item.enable_banking_accounts.includes(:account_provider, :account))

    unlinked_accounts = enable_banking_item.enable_banking_accounts.left_joins(:account_provider).where(account_providers: { id: nil })

    if unlinked_accounts.any?
      enable_banking_item.update!(pending_account_setup: true)
      update_status(sync, :accounts_need_setup, count: unlinked_accounts.count)
    else
      enable_banking_item.update!(pending_account_setup: false)
    end

    # Phase 3: Process transactions for linked and visible accounts only
    linked_account_ids = enable_banking_item.enable_banking_accounts
      .joins(:account_provider)
      .joins(:account)
      .merge(Account.visible)
      .pluck("accounts.id")

    if linked_account_ids.any?
      update_status(sync, :processing_transactions)
      enable_banking_item.process_accounts

      # Collect transaction statistics
      collect_transaction_stats(sync, account_ids: linked_account_ids, source: "enable_banking")

      # Phase 4: Schedule balance calculations for linked accounts
      update_status(sync, :calculating_balances)
      enable_banking_item.schedule_account_syncs(
        parent_sync: sync,
        window_start_date: sync.window_start_date,
        window_end_date: sync.window_end_date
      )
    end

    collect_health_stats(sync, errors: nil)
  rescue => e
    collect_health_stats(sync, errors: [ { message: e.message, category: "sync_error" } ])
    raise
  end

  def perform_post_sync
    # no-op
  end

  private

    def update_status(sync, key, **options)
      return unless sync.respond_to?(:status_text)

      sync.update!(status_text: I18n.t("enable_banking_items.syncer.#{key}", **options))
    end
end
