class IbkrItem::Syncer
  include SyncStats::Collector

  attr_reader :ibkr_item

  def initialize(ibkr_item)
    @ibkr_item = ibkr_item
  end

  def perform_sync(sync)
    update_status(sync, :checking_credentials)
    unless ibkr_item.credentials_configured?
      ibkr_item.update!(status: :requires_update)
      raise Provider::IbkrFlex::ConfigurationError, I18n.t("ibkr_items.syncer.credentials_missing")
    end

    update_status(sync, :importing_accounts)
    ibkr_item.import_latest_ibkr_data

    update_status(sync, :checking_account_configuration)
    collect_setup_stats(sync, provider_accounts: ibkr_item.ibkr_accounts.to_a)

    unlinked_accounts = ibkr_item.ibkr_accounts.left_joins(:account_provider).where(account_providers: { id: nil })
    linked_accounts = ibkr_item.ibkr_accounts.joins(:account).merge(Account.visible)

    if unlinked_accounts.any?
      ibkr_item.update!(pending_account_setup: true)
      update_status(sync, :accounts_need_setup, count: unlinked_accounts.count)
    else
      ibkr_item.update!(pending_account_setup: false)
    end

    if linked_accounts.any?
      update_status(sync, :processing_holdings_and_activity)
      ibkr_item.process_accounts

      update_status(sync, :calculating_balances)
      ibkr_item.schedule_account_syncs(
        parent_sync: sync,
        window_start_date: sync.window_start_date,
        window_end_date: sync.window_end_date
      )

      account_ids = linked_accounts.includes(:account).filter_map { |provider_account| provider_account.account&.id }
      collect_transaction_stats(sync, account_ids: account_ids, source: "ibkr") if account_ids.any?
      collect_trades_stats(sync, account_ids: account_ids, source: "ibkr") if account_ids.any?
      collect_holdings_stats(sync, holdings_count: count_holdings, label: "processed")
    end

    collect_health_stats(sync, errors: nil)
  rescue Provider::IbkrFlex::AuthenticationError, Provider::IbkrFlex::ConfigurationError => e
    ibkr_item.update!(status: :requires_update)
    message = if e.is_a?(Provider::IbkrFlex::ConfigurationError)
      I18n.t("ibkr_items.syncer.credentials_missing")
    else
      I18n.t("ibkr_items.syncer.credentials_invalid")
    end
    collect_health_stats(sync, errors: [ { message: message, category: "auth_error" } ])
    raise
  rescue => e
    collect_health_stats(sync, errors: [ { message: I18n.t("ibkr_items.syncer.failed"), category: "sync_error" } ])
    raise
  end

  def perform_post_sync
  end

  private

    def update_status(sync, key, **options)
      return unless sync.respond_to?(:status_text)

      sync.update!(status_text: I18n.t("ibkr_items.syncer.#{key}", **options))
    end

    def count_holdings
      ibkr_item.ibkr_accounts.sum { |account| Array(account.raw_holdings_payload).size }
    end
end
