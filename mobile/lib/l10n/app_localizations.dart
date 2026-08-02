// Generated from ARB files. Do not edit by hand.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('en'),
  ];

  String get appTitle;

  String get commonCancel;

  String get commonSave;

  String get commonTryAgain;

  String get commonDelete;

  String get commonAll;

  String get commonRefresh;

  String get commonClose;

  String get commonUndo;

  String commonButtonLoading(String label);

  String get chatSuggestionNetWorth;

  String get chatSuggestionSpending;

  String get chatSuggestionSavings;

  String get chatSuggestionExpenses;

  String get loginEmailLabel;

  String get loginEmailRequired;

  String get loginEmailInvalid;

  String get loginPasswordLabel;

  String get loginPasswordRequired;

  String get loginSignIn;

  String get loginSignInWithGoogle;

  String get loginMfaLabel;

  String get loginApiKeyLabel;

  String get navHome;

  String get navIntro;

  String get navAssistant;

  String get navMore;

  String get dashboardSyncError;

  String get dashboardSyncFailed;

  String get dashboardRefreshing;

  String get dashboardAccountsUpdated;

  String get dashboardSyncing;

  String get dashboardSynced;

  String get dashboardErrorLoadingAccounts;

  String get dashboardNoAccounts;

  String get dashboardNoAccountsSubtitle;

  String get dashboardFilterEmpty;

  String get chatListTitle;

  String get chatListNewChat;

  String get chatListEmpty;

  String get chatListEmptySubtitle;

  String get chatListDeleteTitle;

  String get chatConversationNewTitle;

  String get chatConversationMessageHint;

  String chatConversationGreetingWithName(String firstName);

  String get chatConversationGreetingNoName;

  String get transactionFormNewTitle;

  String get transactionFormTypeLabel;

  String get transactionFormTypeExpense;

  String get transactionFormTypeIncome;

  String get transactionFormAmountLabel;

  String get transactionFormAmountRequired;

  String get transactionFormAmountInvalid;

  String get transactionFormDateLabel;

  String get transactionFormNameLabel;

  String get transactionFormCategoryLabel;

  String get transactionEditTitle;

  String get transactionEditNameLabel;

  String get transactionEditNameRequired;

  String get transactionEditNotesLabel;

  String get transactionEditCategoryLabel;

  String get transactionEditMerchantLabel;

  String get transactionEditTagsLabel;

  String get transactionEditSaving;

  String get transactionsListDeleteTitle;

  String transactionsListDeleteSingleContent(String name);

  String get transactionsListDeleteMultiTitle;

  String get transactionsListDeleteMultiContent;

  String get transactionsListEmpty;

  String get transactionsListAuthFailed;

  String get transactionsListNoTransactionsYet;

  String get transactionsListEmptyAddFirst;

  String get transactionsListNoCategoryMatch;

  String get transactionsListRetry;

  String get transactionsListDeletedSuccess;

  String get transactionsListSingleDeleteFailed;

  String transactionsListDeletedMulti(int count);

  String get transactionsListDeleteFailed;

  String get transactionsListDeleteNoToken;

  String get transactionsListUndoTitle;

  String get transactionsListUndoRemovePending;

  String get transactionsListUndoRestoreConfirm;

  String get transactionsListUndoPendingRemoved;

  String get transactionsListUndoRestored;

  String get transactionsListUndoFailed;

  String get settingsSectionDisplay;

  String get settingsSectionConnection;

  String get settingsSectionDataManagement;

  String get settingsSectionSecurity;

  String get settingsSectionDangerZone;

  String get settingsThemeLabel;

  String get settingsThemeSystem;

  String get settingsThemeLight;

  String get settingsThemeDark;

  String get settingsProxyHeadersLabel;

  String get settingsPrivacyHideAmountsLabel;

  String get settingsPrivacyHideAmountsContent;

  String get settingsBiometricLabel;

  String get settingsBiometricEnable;

  String get settingsBiometricEnableContent;

  String get settingsCheckForUpdates;

  String get settingsUpdateAvailableTitle;

  String settingsUpdateAvailableContent(String version);

  String get settingsUpdateNewerVersionFallback;

  String get settingsUpdateNow;

  String get settingsNoUpdateAvailable;

  String get settingsUpdateError;

  String get settingsClearDataTitle;

  String get settingsClearDataContent;

  String get settingsClearData;

  String get settingsClearDataSuccess;

  String get settingsDeleteAccountTitle;

  String get settingsDeleteAccount;

  String get settingsSignOutTitle;

  String get settingsSignOutContent;

  String get settingsSignOut;

  String get settingsDebugLogs;

  String get ssoOnboardingTitle;

  String get ssoOnboardingTabLink;

  String get ssoOnboardingTabCreate;

  String get ssoOnboardingFirstNameLabel;

  String get ssoOnboardingLastNameLabel;

  String get ssoOnboardingLinkButton;

  String get ssoOnboardingCreateButton;

  String get ssoOnboardingAcceptInvitation;

  String get calendarTitle;

  String get calendarAccountTypeSection;

  String get calendarSegmentAssets;

  String get calendarSegmentLiabilities;

  String get calendarSelectAccount;

  String get calendarMonthlyChange;

  String get calendarNoTransactions;

  String get moreCalendar;

  String get moreCalendarSubtitle;

  String get moreRecentTransactions;

  String get moreRecentTransactionsSubtitle;

  String get biometricTitle;

  String get biometricSubtitle;

  String get biometricUnlock;

  String get biometricAuthenticating;

  String get biometricLogOut;

  String get backendConfigTitle;

  String get backendConfigSubtitle;

  String get backendConfigExampleUrlsLabel;

  String get backendConfigUrlLabel;

  String get backendConfigUrlHint;

  String get backendConfigProxyHeadersLabel;

  String get backendConfigProxyHeadersSubtitle;

  String backendConfigProxyHeadersCount(int count);

  String get backendConfigTesting;

  String get backendConfigTestButton;

  String get backendConfigContinueButton;

  String get backendConfigChangeHint;

  String get recentTransactionsTitle;

  String get recentTransactionsEmpty;

  String get recentTransactionsDisplayLimit;

  String recentTransactionsShowN(int count);

  String get recentTransactionsPullToRefresh;

  String get logViewerTitle;

  String get logViewerFilterAll;

  String get logViewerFilterInfo;

  String get logViewerFilterWarning;

  String get logViewerFilterError;

  String get logViewerFilterDebug;

  String get logViewerAutoScrollEnable;

  String get logViewerAutoScrollDisable;

  String get logViewerCopyLogs;

  String get logViewerClearLogs;

  String get logViewerLogsCopied;

  String get logViewerEmpty;

  String get connectivityOffline;

  String connectivityPendingSync(int count);

  String get connectivitySyncNow;

  String get proxyHeadersAddHeader;

  String get proxyHeadersNameLabel;

  String get proxyHeadersNameHint;

  String get proxyHeadersValueLabel;

  String get proxyHeadersRemove;

  String get accountDetailRefreshTooltip;

  String get accountDetailRecentBalanceHistory;

  String get accountDetailTopHoldings;

  String get accountDetailHoldingFallback;

  String accountDetailCashChip(String amount);

  String get biometricLockFailedRetry;

  String get settingsBiometricVerifyReason;

  String get settingsBiometricFailed;

  String get settingsUpdateOpenStoreError;

  String get settingsClearDataFailed;

  String get settingsClearDataSuccessDetailed;

  String get settingsContactOpenLinkError;

  String get settingsResetAccountContent;

  String get settingsResetAccount;

  String get settingsResetAccountInitiated;

  String get settingsResetAccountFailed;

  String get settingsDeleteAccountConfirmContent;

  String get settingsDeleteAccountFailed;

  String get settingsProxyHeadersNote;

  String get settingsProxyHeadersSaved;

  String get settingsProxyHeadersSaveFailed;

  String settingsAppVersion(String version);

  String get settingsCheckForUpdatesSubtitle;

  String get settingsContactUs;

  String get settingsDebugLogsSemantics;

  String get settingsDebugLogsSubtitle;

  String get settingsGroupByAccountType;

  String get settingsGroupByAccountTypeSubtitle;

  String get settingsProxyHeadersTileTitle;

  String get settingsProxyHeadersTileSubtitleEmpty;

  String settingsProxyHeadersTileSubtitleCount(int count);

  String get settingsClearDataTileSubtitle;

  String get settingsResetAccountTileSubtitle;

  String get settingsDeleteAccountTileSubtitle;

  String get settingsUserFallback;

  String chatListDeleteMultiContent(int count);

  String get chatListDeletedSuccess;

  String get chatListDeleteFailed;

  String get chatListError;

  String get chatListJustNow;

  String chatListDeleteSingleContent(String title);

  String get loginSignUpOpenError;

  String get loginApiKeyDialogTitle;

  String get loginApiKeyDialogBody;

  String get loginApiKeyInvalid;

  String get loginApiKeySignIn;

  String get loginDemoOrSignUpPrefix;

  String get loginSignUpLink;

  String get loginSignUpSuffix;

  String get loginMfaInfo;

  String get loginMfaCodeRequired;

  String get loginOrDivider;

  String get loginServerUrlHeading;

  String get loginApiKeyLoginButton;

  String get loginBackendSettingsTooltip;

  String get transactionEditSessionExpired;

  String get transactionEditUpdated;

  String get transactionEditUpdateFailed;

  String transactionEditNameMaxLength(int max);

  String get transactionEditNameInvalidChars;

  String transactionEditNotesMaxLength(int max);

  String get transactionEditNotesInvalidChars;

  String get transactionEditNoCategory;

  String get transactionEditCurrentCategory;

  String get transactionEditNoMerchant;

  String get transactionEditCurrentMerchant;

  String get transactionEditNoTags;

  String get transactionEditUnknownTag;

  String get transactionEditSyncedOnly;

  String get transactionEditCategoryHelper;

  String get transactionEditMerchantHelper;

  String get transactionFormSessionExpired;

  String get transactionFormAmountRequiredPrompt;

  String get transactionFormAmountInvalidNumber;

  String get transactionFormAmountTooSmall;

  String get transactionFormCreateSuccessOnline;

  String get transactionFormCreateSuccessOffline;

  String get transactionFormCreateFailed;

  String transactionFormGenericError(String error);

  String get transactionFormLess;

  String get transactionFormMore;

  String get transactionFormDateHelper;

  String get transactionFormNameHelper;

  String get transactionFormCategoryLoading;

  String get transactionFormCategoryHelper;

  String get transactionFormNoCategory;

  String get transactionFormCreateButton;

  String get transactionFormAmountHelper;

  String get logViewerClearConfirm;

  String get logViewerClear;

  String get chatConversationEditTitle;

  String get chatConversationTitleLabel;

  String get chatConversationRefreshTooltip;

  String get chatConversationLoadError;

  String get navEnableAiChatTitle;

  String get navEnableAiChatContent;

  String get navEnableAiChatNotNow;

  String get navEnableAiChatConfirm;

  String get navEnableAiChatFailed;

  String get transactionsListEditTooltip;

  String get connectivitySignInToSync;

  String get connectivitySyncSuccess;

  String get connectivitySyncFailed;

  String get connectivityAuthFailed;

  String ssoOnboardingSignedInAs(String email);

  String get ssoOnboardingGoogleVerified;

  String get ssoOnboardingLinkCredentialsNote;

  String get ssoOnboardingPendingInvitationNote;

  String get ssoOnboardingCreateIdentityNote;

  String get ssoOnboardingFirstNameRequired;

  String get ssoOnboardingLastNameRequired;

  String get backendConfigTimeout;

  String get backendConfigSuccess;

  String backendConfigServerError(int code);

  String backendConfigConnectionFailed(String error);

  String backendConfigSaveFailed(String error);

  String get backendConfigUrlRequired;

  String get backendConfigUrlScheme;

  String get backendConfigUrlInvalid;

  String get backendConfigHeadersHelp;

  String get recentTransactionsUnknownAccount;

  String get accountDetailUnavailable;

  String chatListMinutesAgo(int minutes);

  String chatListHoursAgo(int hours);

  String chatListDaysAgo(int days);

  String get chatConversationStartFailed;

  String get introComingSoon;

  String get introComingSoonBody;

  String get navTogglePrivacy;

  String get accountCardTransactions;

  String get netWorthTitle;

  String get netWorthOutdated;

  String get chatThinking;

  String get syncStatusPending;

  String get syncStatusPendingSemantics;

  String get syncStatusDeleting;

  String get syncStatusDeletingSemantics;

  String get syncStatusFailed;

  String get syncStatusFailedSemantics;

  String get transactionFormDefaultNote;

  String get biometricUnlockReason;

  String get accountTypeDepository;

  String get accountTypeCreditCard;

  String get accountTypeInvestment;

  String get accountTypeLoan;

  String get accountTypeProperty;

  String get accountTypeVehicle;

  String get accountTypeCrypto;

  String get accountTypeOtherAsset;

  String get accountTypeOtherLiability;

  String get defaultCategoryIncome;

  String get defaultCategoryFoodAndDrink;

  String get defaultCategoryGroceries;

  String get defaultCategoryShopping;

  String get defaultCategoryTransportation;

  String get defaultCategoryTravel;

  String get defaultCategoryEntertainment;

  String get defaultCategoryHealthcare;

  String get defaultCategoryPersonalCare;

  String get defaultCategoryHomeImprovement;

  String get defaultCategoryMortgageRent;

  String get defaultCategoryUtilities;

  String get defaultCategorySubscriptions;

  String get defaultCategoryInsurance;

  String get defaultCategorySportsAndFitness;

  String get defaultCategoryGiftsAndDonations;

  String get defaultCategoryTaxes;

  String get defaultCategoryLoanPayments;

  String get defaultCategoryServices;

  String get defaultCategoryFees;

  String get defaultCategorySavingsAndInvestments;

  String get defaultCategoryInvestmentContributions;

  String get proxyHeadersNameRequired;

  String get proxyHeadersNameInvalid;

  String get proxyHeadersNameManaged;

  String get proxyHeadersValueRequired;

  String get proxyHeadersValueInvalid;

  String get clientErrorNetworkUnavailable;

  String get clientErrorRequestTimedOut;

  String get clientErrorInvalidServerResponse;

  String get clientErrorUnexpected;

  String get clientErrorLoginFailed;

  String get clientErrorInvalidSsoResponse;

  String get clientErrorAuthorizationExchangeFailed;

  String get clientErrorAccountLinkFailed;

  String get clientErrorAccountCreationFailed;

  String get clientErrorOfflineAccounts;

  String get clientErrorSecureConnection;

  String get clientErrorSendMessageFailed;

  String get clientErrorDeleteChatFailed;

  String get clientErrorAssistantTimedOut;

  String get clientErrorAuthenticationCodeInvalid;

  String get clientErrorBrowserOpenFailed;

  String get clientErrorSignInStartFailed;

  String get clientErrorSignInFailed;

  String get clientErrorMissingSsoSession;

  String get clientErrorTransactionEditRequiresOnline;

  String get clientErrorTransactionUploadFailed;

  String get clientErrorFetchTransactionsFailed;

  String get clientErrorFetchTransactionFailed;

  String get clientErrorSyncInProgress;

  String get clientErrorAiFeaturesDisabled;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale".',
  );
}
