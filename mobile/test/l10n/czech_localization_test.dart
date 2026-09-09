import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sure_mobile/l10n/app_localizations.dart';
import 'package:sure_mobile/l10n/app_localizations_cs.dart';
import 'package:sure_mobile/l10n/client_errors.dart';
import 'package:sure_mobile/models/account.dart';
import 'package:sure_mobile/models/category.dart';

void main() {
  final l = AppLocalizationsCs();

  test('registers Czech as a supported application locale', () {
    expect(AppLocalizations.supportedLocales, contains(const Locale('cs')));
    expect(l.commonButtonLoading('Uložit'), 'Uložit, probíhá načítání');
  });

  test('uses Czech plural forms', () {
    expect(l.transactionsListDeletedMulti(1), 'Byla odstraněna 1 transakce');
    expect(l.transactionsListDeletedMulti(3), 'Byly odstraněny 3 transakce');
    expect(l.transactionsListDeletedMulti(5), 'Bylo odstraněno 5 transakcí');
  });

  test('localizes account types without changing their stable values', () {
    final account = Account(
      id: 'account-id',
      name: 'Běžný účet',
      balance: '1000',
      currency: 'CZK',
      accountType: 'depository',
      classification: 'asset',
    );

    expect(account.accountType, 'depository');
    expect(account.displayAccountType(l), 'Bankovní účet');
  });

  test('uses numeric minor units instead of parsing localized balances', () {
    final czechAccount = Account(
      id: 'czk-account',
      name: 'Běžný účet',
      balance: '1\u00a0234,56\u00a0Kč',
      balanceCents: 123456,
      currency: 'CZK',
      accountType: 'depository',
      classification: 'asset',
    );
    final yenAccount = Account(
      id: 'jpy-account',
      name: 'Japonský účet',
      balance: '1,234\u00a0JPY',
      balanceCents: 1234,
      currency: 'JPY',
      accountType: 'depository',
      classification: 'asset',
    );

    expect(czechAccount.balanceAsDouble, 1234.56);
    expect(yenAccount.balanceAsDouble, 1234);
  });

  test('localizes default categories without changing their identifiers', () {
    final category = Category(
      id: 'category-id',
      name: 'Food & Drink',
      color: '#000000',
      icon: 'utensils',
    );

    expect(category.name, 'Food & Drink');
    expect(category.localizedDisplayName(l), 'Jídlo a nápoje');
    expect(
      Category.localizedDefaultName(l, category.name),
      'Jídlo a nápoje',
    );
  });

  test('maps stable client errors to Czech messages', () {
    expect(
      localizedClientError(l, ClientError.networkUnavailable),
      'Síť není dostupná. Zkontrolujte připojení a zkuste to znovu.',
    );
    expect(
      localizedClientError(l, ClientError.transactionSyncedOnly),
      'Z mobilu lze upravovat pouze synchronizované transakce.',
    );
    expect(
      localizedClientError(l, 'English server details'),
      'Něco se pokazilo. Zkuste to prosím znovu.',
    );
  });
}
