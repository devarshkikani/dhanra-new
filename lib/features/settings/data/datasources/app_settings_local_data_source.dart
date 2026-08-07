import 'package:dhanra_new/features/settings/domain/entities/app_settings_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class AppSettingsLocalDataSource {
  static const String _keyTheme = 'settings_theme';
  static const String _keyCurrencyCode = 'settings_currency_code';
  static const String _keyCurrencySymbol = 'settings_currency_symbol';
  static const String _keyLanguageCode = 'settings_language_code';
  static const String _keyPinEnabled = 'settings_pin_enabled';
  static const String _keyPinCode = 'settings_pin_code';
  static const String _keyBiometricEnabled = 'settings_biometric_enabled';

  final SharedPreferences _prefs;

  AppSettingsLocalDataSource(this._prefs);

  AppSettingsEntity getSettings() {
    final themeIndex = _prefs.getInt(_keyTheme) ?? AppThemePreference.dark.index;
    final themePref = AppThemePreference.values[themeIndex.clamp(0, AppThemePreference.values.length - 1)];

    return AppSettingsEntity(
      themePreference: themePref,
      currencyCode: _prefs.getString(_keyCurrencyCode) ?? 'INR',
      currencySymbol: _prefs.getString(_keyCurrencySymbol) ?? '₹',
      languageCode: _prefs.getString(_keyLanguageCode) ?? 'en',
      isPinLockEnabled: _prefs.getBool(_keyPinEnabled) ?? false,
      pinCode: _prefs.getString(_keyPinCode),
      isBiometricEnabled: _prefs.getBool(_keyBiometricEnabled) ?? false,
    );
  }

  Future<void> saveSettings(AppSettingsEntity settings) async {
    await _prefs.setInt(_keyTheme, settings.themePreference.index);
    await _prefs.setString(_keyCurrencyCode, settings.currencyCode);
    await _prefs.setString(_keyCurrencySymbol, settings.currencySymbol);
    await _prefs.setString(_keyLanguageCode, settings.languageCode);
    await _prefs.setBool(_keyPinEnabled, settings.isPinLockEnabled);
    if (settings.pinCode != null) {
      await _prefs.setString(_keyPinCode, settings.pinCode!);
    } else {
      await _prefs.remove(_keyPinCode);
    }
    await _prefs.setBool(_keyBiometricEnabled, settings.isBiometricEnabled);
  }
}
