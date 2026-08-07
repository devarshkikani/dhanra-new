import 'package:equatable/equatable.dart';

enum AppThemePreference { system, dark, light }

extension AppThemePreferenceX on AppThemePreference {
  String get displayName {
    switch (this) {
      case AppThemePreference.system:
        return 'System Default';
      case AppThemePreference.dark:
        return 'Dark Mode';
      case AppThemePreference.light:
        return 'Light Mode';
    }
  }
}

class AppSettingsEntity extends Equatable {
  final AppThemePreference themePreference;
  final String currencyCode; // e.g. INR, USD, EUR, GBP
  final String currencySymbol; // e.g. ₹, $, €, £
  final String languageCode; // e.g. en, hi
  final bool isPinLockEnabled;
  final String? pinCode;
  final bool isBiometricEnabled;

  const AppSettingsEntity({
    this.themePreference = AppThemePreference.dark,
    this.currencyCode = 'INR',
    this.currencySymbol = '₹',
    this.languageCode = 'en',
    this.isPinLockEnabled = false,
    this.pinCode,
    this.isBiometricEnabled = false,
  });

  AppSettingsEntity copyWith({
    AppThemePreference? themePreference,
    String? currencyCode,
    String? currencySymbol,
    String? languageCode,
    bool? isPinLockEnabled,
    String? pinCode,
    bool? isBiometricEnabled,
  }) {
    return AppSettingsEntity(
      themePreference: themePreference ?? this.themePreference,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      languageCode: languageCode ?? this.languageCode,
      isPinLockEnabled: isPinLockEnabled ?? this.isPinLockEnabled,
      pinCode: pinCode ?? this.pinCode,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }

  @override
  List<Object?> get props => [
        themePreference,
        currencyCode,
        currencySymbol,
        languageCode,
        isPinLockEnabled,
        pinCode,
        isBiometricEnabled,
      ];
}
