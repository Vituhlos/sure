import 'dart:math' as math;

import 'package:intl/intl.dart';

import '../utils/json_parsing.dart';
import '../l10n/app_localizations.dart';
import '../utils/amount_parser.dart';

class Account {
  final String id;
  final String name;
  final String balance;
  final int? balanceCents;
  final String? cashBalance;
  final int? cashBalanceCents;
  final String currency;
  final String? classification;
  final String accountType;
  final String? subtype;
  final String? status;
  final String? institutionName;
  final String? institutionDomain;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Account({
    required this.id,
    required this.name,
    required this.balance,
    this.balanceCents,
    this.cashBalance,
    this.cashBalanceCents,
    required this.currency,
    this.classification,
    required this.accountType,
    this.subtype,
    this.status,
    this.institutionName,
    this.institutionDomain,
    this.createdAt,
    this.updatedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'].toString(),
      name: JsonParsing.parseRequiredString(json['name'], 'account name'),
      balance: JsonParsing.parseRequiredString(
        json['balance'],
        'account balance',
      ),
      balanceCents: JsonParsing.parseInt(json['balance_cents']),
      cashBalance: JsonParsing.parseString(json['cash_balance']),
      cashBalanceCents: JsonParsing.parseInt(json['cash_balance_cents']),
      currency: JsonParsing.parseRequiredString(
        json['currency'],
        'account currency',
      ),
      classification: JsonParsing.parseString(json['classification']),
      accountType: JsonParsing.parseRequiredString(
        json['account_type'],
        'account type',
      ),
      subtype: JsonParsing.parseString(json['subtype']),
      status: JsonParsing.parseString(json['status']),
      institutionName: JsonParsing.parseString(json['institution_name']),
      institutionDomain: JsonParsing.parseString(json['institution_domain']),
      createdAt: JsonParsing.parseDateTime(json['created_at']),
      updatedAt: JsonParsing.parseDateTime(json['updated_at']),
    );
  }

  bool get isAsset => classification == 'asset';
  bool get isLiability => classification == 'liability';

  double get balanceAsDouble {
    final minorUnits = balanceCents;
    if (minorUnits != null) {
      try {
        final decimalDigits =
            NumberFormat.currency(name: currency).decimalDigits ?? 2;
        return minorUnits / math.pow(10, decimalDigits);
      } catch (_) {
        // Fall back to parsing the formatted value for unknown currencies.
      }
    }

    try {
      return AmountParser.parse(balance).value;
    } on FormatException {
      return 0.0;
    }
  }

  String displayAccountType(AppLocalizations l) {
    switch (accountType) {
      case 'depository':
        return l.accountTypeDepository;
      case 'credit_card':
        return l.accountTypeCreditCard;
      case 'investment':
        return l.accountTypeInvestment;
      case 'loan':
        return l.accountTypeLoan;
      case 'property':
        return l.accountTypeProperty;
      case 'vehicle':
        return l.accountTypeVehicle;
      case 'crypto':
        return l.accountTypeCrypto;
      case 'other_asset':
        return l.accountTypeOtherAsset;
      case 'other_liability':
        return l.accountTypeOtherLiability;
      default:
        return accountType;
    }
  }
}
