import '../l10n/app_localizations.dart';

class Category {
  final String id;
  final String name;
  final String? color;
  final String? icon;
  final Category? parent;
  final int subcategoriesCount;

  Category({
    required this.id,
    required this.name,
    this.color,
    this.icon,
    this.parent,
    this.subcategoriesCount = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    Category? parent;
    if (json['parent'] != null && json['parent'] is Map) {
      parent = Category.fromJson(Map<String, dynamic>.from(json['parent']));
    }

    return Category(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      color: json['color']?.toString(),
      icon: json['icon']?.toString(),
      parent: parent,
      subcategoriesCount: json['subcategories_count'] as int? ?? 0,
    );
  }

  /// Display name including full ancestor path for subcategories
  String get displayName {
    final parts = <String>[];
    Category? current = this;
    while (current != null) {
      parts.add(current.name);
      current = current.parent;
    }
    return parts.reversed.join(' > ');
  }

  String localizedDisplayName(AppLocalizations l) {
    final parts = <String>[];
    Category? current = this;
    while (current != null) {
      parts.add(current._localizedOwnName(l));
      current = current.parent;
    }
    return parts.reversed.join(' > ');
  }

  String _localizedOwnName(AppLocalizations l) {
    return switch ((name, icon)) {
      ('Income', 'circle-dollar-sign') => l.defaultCategoryIncome,
      ('Food & Drink', 'utensils') => l.defaultCategoryFoodAndDrink,
      ('Groceries', 'shopping-bag') => l.defaultCategoryGroceries,
      ('Shopping', 'shopping-cart') => l.defaultCategoryShopping,
      ('Transportation', 'bus') => l.defaultCategoryTransportation,
      ('Travel', 'plane') => l.defaultCategoryTravel,
      ('Entertainment', 'drama') => l.defaultCategoryEntertainment,
      ('Healthcare', 'pill') => l.defaultCategoryHealthcare,
      ('Personal Care', 'scissors') => l.defaultCategoryPersonalCare,
      ('Home Improvement', 'hammer') => l.defaultCategoryHomeImprovement,
      ('Mortgage / Rent', 'home') => l.defaultCategoryMortgageRent,
      ('Utilities', 'lightbulb') => l.defaultCategoryUtilities,
      ('Subscriptions', 'wifi') => l.defaultCategorySubscriptions,
      ('Insurance', 'shield') => l.defaultCategoryInsurance,
      ('Sports & Fitness', 'dumbbell') => l.defaultCategorySportsAndFitness,
      ('Gifts & Donations', 'hand-helping') => l.defaultCategoryGiftsAndDonations,
      ('Taxes', 'landmark') => l.defaultCategoryTaxes,
      ('Loan Payments', 'credit-card') => l.defaultCategoryLoanPayments,
      ('Services', 'briefcase') => l.defaultCategoryServices,
      ('Fees', 'receipt') => l.defaultCategoryFees,
      ('Savings & Investments', 'piggy-bank') => l.defaultCategorySavingsAndInvestments,
      ('Investment Contributions', 'trending-up') => l.defaultCategoryInvestmentContributions,
      _ => name,
    };
  }

  static String localizedDefaultName(AppLocalizations l, String name) {
    return switch (name) {
      'Income' => l.defaultCategoryIncome,
      'Food & Drink' => l.defaultCategoryFoodAndDrink,
      'Groceries' => l.defaultCategoryGroceries,
      'Shopping' => l.defaultCategoryShopping,
      'Transportation' => l.defaultCategoryTransportation,
      'Travel' => l.defaultCategoryTravel,
      'Entertainment' => l.defaultCategoryEntertainment,
      'Healthcare' => l.defaultCategoryHealthcare,
      'Personal Care' => l.defaultCategoryPersonalCare,
      'Home Improvement' => l.defaultCategoryHomeImprovement,
      'Mortgage / Rent' => l.defaultCategoryMortgageRent,
      'Utilities' => l.defaultCategoryUtilities,
      'Subscriptions' => l.defaultCategorySubscriptions,
      'Insurance' => l.defaultCategoryInsurance,
      'Sports & Fitness' => l.defaultCategorySportsAndFitness,
      'Gifts & Donations' => l.defaultCategoryGiftsAndDonations,
      'Taxes' => l.defaultCategoryTaxes,
      'Loan Payments' => l.defaultCategoryLoanPayments,
      'Services' => l.defaultCategoryServices,
      'Fees' => l.defaultCategoryFees,
      'Savings & Investments' => l.defaultCategorySavingsAndInvestments,
      'Investment Contributions' =>
        l.defaultCategoryInvestmentContributions,
      _ => name,
    };
  }
}
