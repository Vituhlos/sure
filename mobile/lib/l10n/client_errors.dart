import 'app_localizations.dart';

abstract final class ClientError {
  static const networkUnavailable = 'network_unavailable';
  static const requestTimedOut = 'request_timed_out';
  static const invalidServerResponse = 'invalid_server_response';
  static const unexpected = 'unexpected_error';
  static const invalidApiKey = 'invalid_api_key';
  static const loginFailed = 'login_failed';
  static const invalidSsoResponse = 'invalid_sso_response';
  static const authorizationExchangeFailed = 'authorization_exchange_failed';
  static const accountLinkFailed = 'account_link_failed';
  static const accountCreationFailed = 'account_creation_failed';
  static const fetchAccountsFailed = 'fetch_accounts_failed';
  static const offlineAccounts = 'offline_accounts';
  static const secureConnectionFailed = 'secure_connection_failed';
  static const fetchChatsFailed = 'fetch_chats_failed';
  static const fetchChatFailed = 'fetch_chat_failed';
  static const createChatFailed = 'create_chat_failed';
  static const sendMessageFailed = 'send_message_failed';
  static const deleteChatFailed = 'delete_chat_failed';
  static const deleteChatsFailed = 'delete_chats_failed';
  static const assistantTimedOut = 'assistant_timed_out';
  static const sessionExpired = 'session_expired';
  static const authenticationCodeInvalid = 'authentication_code_invalid';
  static const browserOpenFailed = 'browser_open_failed';
  static const signInStartFailed = 'sign_in_start_failed';
  static const signInFailed = 'sign_in_failed';
  static const missingSsoSession = 'missing_sso_session';
  static const transactionSyncedOnly = 'transaction_synced_only';
  static const transactionEditRequiresOnline =
      'transaction_edit_requires_online';
  static const transactionUpdateFailed = 'transaction_update_failed';
  static const transactionDeleteFailed = 'transaction_delete_failed';
  static const transactionsDeleteFailed = 'transactions_delete_failed';
  static const transactionUndoFailed = 'transaction_undo_failed';
  static const syncRequiresOnline = 'sync_requires_online';
  static const transactionUploadFailed = 'transaction_upload_failed';
  static const transactionCreateFailed = 'transaction_create_failed';
  static const fetchTransactionsFailed = 'fetch_transactions_failed';
  static const fetchTransactionFailed = 'fetch_transaction_failed';
  static const resetAccountFailed = 'reset_account_failed';
  static const deleteAccountFailed = 'delete_account_failed';
  static const enableAiFailed = 'enable_ai_failed';
  static const syncInProgress = 'sync_in_progress';
  static const syncFailed = 'sync_failed';
  static const featureDisabled = 'feature_disabled';
  static const notFound = 'not_found';
  static const accountDetailsFailed = 'account_details_failed';
  static const balanceHistoryFailed = 'balance_history_failed';
  static const holdingsFailed = 'holdings_failed';
  static const balanceSheetFailed = 'balance_sheet_failed';
  static const fetchCategoriesFailed = 'fetch_categories_failed';
  static const fetchMerchantsFailed = 'fetch_merchants_failed';
  static const fetchTagsFailed = 'fetch_tags_failed';
}

String localizedClientError(AppLocalizations l, String? error) {
  return switch (error) {
    ClientError.networkUnavailable => l.clientErrorNetworkUnavailable,
    ClientError.requestTimedOut => l.clientErrorRequestTimedOut,
    ClientError.invalidServerResponse => l.clientErrorInvalidServerResponse,
    ClientError.unexpected => l.clientErrorUnexpected,
    ClientError.invalidApiKey => l.loginApiKeyInvalid,
    ClientError.loginFailed => l.clientErrorLoginFailed,
    ClientError.invalidSsoResponse => l.clientErrorInvalidSsoResponse,
    ClientError.authorizationExchangeFailed => l.clientErrorAuthorizationExchangeFailed,
    ClientError.accountLinkFailed => l.clientErrorAccountLinkFailed,
    ClientError.accountCreationFailed => l.clientErrorAccountCreationFailed,
    ClientError.fetchAccountsFailed => l.dashboardErrorLoadingAccounts,
    ClientError.offlineAccounts => l.clientErrorOfflineAccounts,
    ClientError.secureConnectionFailed => l.clientErrorSecureConnection,
    ClientError.fetchChatsFailed => l.chatListError,
    ClientError.fetchChatFailed => l.chatConversationLoadError,
    ClientError.createChatFailed => l.chatConversationStartFailed,
    ClientError.sendMessageFailed => l.clientErrorSendMessageFailed,
    ClientError.deleteChatFailed => l.clientErrorDeleteChatFailed,
    ClientError.deleteChatsFailed => l.chatListDeleteFailed,
    ClientError.assistantTimedOut => l.clientErrorAssistantTimedOut,
    ClientError.sessionExpired => l.transactionEditSessionExpired,
    ClientError.authenticationCodeInvalid => l.clientErrorAuthenticationCodeInvalid,
    ClientError.browserOpenFailed => l.clientErrorBrowserOpenFailed,
    ClientError.signInStartFailed => l.clientErrorSignInStartFailed,
    ClientError.signInFailed => l.clientErrorSignInFailed,
    ClientError.missingSsoSession => l.clientErrorMissingSsoSession,
    ClientError.transactionSyncedOnly => l.transactionEditSyncedOnly,
    ClientError.transactionEditRequiresOnline =>
      l.clientErrorTransactionEditRequiresOnline,
    ClientError.transactionUpdateFailed => l.transactionEditUpdateFailed,
    ClientError.transactionDeleteFailed =>
      l.transactionsListSingleDeleteFailed,
    ClientError.transactionsDeleteFailed => l.transactionsListDeleteFailed,
    ClientError.transactionUndoFailed => l.transactionsListUndoFailed,
    ClientError.syncRequiresOnline => l.connectivityOffline,
    ClientError.transactionUploadFailed =>
      l.clientErrorTransactionUploadFailed,
    ClientError.transactionCreateFailed => l.transactionFormCreateFailed,
    ClientError.fetchTransactionsFailed => l.clientErrorFetchTransactionsFailed,
    ClientError.fetchTransactionFailed => l.clientErrorFetchTransactionFailed,
    ClientError.resetAccountFailed => l.settingsResetAccountFailed,
    ClientError.deleteAccountFailed => l.settingsDeleteAccountFailed,
    ClientError.enableAiFailed => l.navEnableAiChatFailed,
    ClientError.syncInProgress => l.clientErrorSyncInProgress,
    ClientError.syncFailed => l.dashboardSyncFailed,
    ClientError.featureDisabled => l.clientErrorAiFeaturesDisabled,
    ClientError.notFound => l.chatConversationLoadError,
    ClientError.accountDetailsFailed => l.accountDetailUnavailable,
    ClientError.balanceHistoryFailed => l.accountDetailUnavailable,
    ClientError.holdingsFailed => l.accountDetailUnavailable,
    ClientError.balanceSheetFailed => l.dashboardErrorLoadingAccounts,
    ClientError.fetchCategoriesFailed => l.clientErrorUnexpected,
    ClientError.fetchMerchantsFailed => l.clientErrorUnexpected,
    ClientError.fetchTagsFailed => l.clientErrorUnexpected,
    null || '' => l.clientErrorUnexpected,
    _ => l.clientErrorUnexpected,
  };
}
