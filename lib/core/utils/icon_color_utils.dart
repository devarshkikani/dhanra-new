import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:flutter/material.dart';

/// Centralized utility for dynamic icon mapping and hex color parsing.
abstract class IconColorUtils {
  /// Safely converts a hex color string (e.g. "#8B5CF6", "8B5CF6") to a Flutter [Color].
  static Color parseHexColor(String? hex, {Color fallback = AppColors.primary}) {
    if (hex == null || hex.trim().isEmpty) return fallback;
    try {
      final buffer = StringBuffer();
      final cleanHex = hex.trim().replaceAll('#', '');
      if (cleanHex.length == 6) {
        buffer.write('ff');
        buffer.write(cleanHex);
      } else if (cleanHex.length == 8) {
        buffer.write(cleanHex);
      } else {
        return fallback;
      }
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return fallback;
    }
  }

  /// Returns [IconData] for account icon names or falls back to account type icons.
  static IconData getAccountIconData(String? iconName, AccountType type) {
    if (iconName != null) {
      switch (iconName.trim()) {
        case 'account_balance':
        case 'bank':
          return Icons.account_balance_rounded;
        case 'account_balance_wallet':
        case 'wallet':
          return Icons.account_balance_wallet_rounded;
        case 'payments':
        case 'cash':
          return Icons.payments_rounded;
        case 'credit_card':
        case 'card':
          return Icons.credit_card_rounded;
        case 'savings':
          return Icons.savings_rounded;
        case 'trending_up':
          return Icons.trending_up_rounded;
      }
    }
    switch (type) {
      case AccountType.bank:
        return Icons.account_balance_rounded;
      case AccountType.wallet:
        return Icons.account_balance_wallet_rounded;
      case AccountType.cash:
        return Icons.payments_rounded;
      case AccountType.creditCard:
        return Icons.credit_card_rounded;
    }
  }

  /// Returns [IconData] for category icon names.
  static IconData getCategoryIconData(String? iconName) {
    if (iconName == null || iconName.trim().isEmpty) {
      return Icons.category_rounded;
    }
    switch (iconName.trim()) {
      case 'fastfood':
      case 'food':
        return Icons.fastfood_rounded;
      case 'restaurant':
      case 'dining':
        return Icons.restaurant_rounded;
      case 'coffee':
      case 'cafe':
        return Icons.coffee_rounded;
      case 'local_grocery_store':
      case 'groceries':
        return Icons.local_grocery_store_rounded;
      case 'shopping_bag':
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'receipt_long':
      case 'bills':
      case 'utilities':
        return Icons.receipt_long_rounded;
      case 'directions_car':
      case 'fuel':
      case 'transport':
        return Icons.directions_car_rounded;
      case 'movie':
      case 'entertainment':
        return Icons.movie_rounded;
      case 'medical_services':
      case 'health':
        return Icons.medical_services_rounded;
      case 'flight':
      case 'travel':
        return Icons.flight_rounded;
      case 'work':
      case 'salary':
        return Icons.work_rounded;
      case 'laptop_mac':
      case 'freelance':
      case 'tech':
        return Icons.laptop_mac_rounded;
      case 'trending_up':
      case 'investments':
        return Icons.trending_up_rounded;
      case 'card_giftcard':
      case 'gift':
        return Icons.card_giftcard_rounded;
      case 'school':
      case 'education':
        return Icons.school_rounded;
      case 'home':
      case 'rent':
        return Icons.home_rounded;
      case 'subscriptions':
      case 'digital':
        return Icons.subscriptions_rounded;
      case 'account_balance':
      case 'loans':
        return Icons.account_balance_rounded;
      case 'fitness_center':
      case 'gym':
        return Icons.fitness_center_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
