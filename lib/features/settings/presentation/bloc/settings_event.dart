import 'package:dhanra_new/features/settings/domain/entities/app_settings_entity.dart';
import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

class UpdateThemePreferenceEvent extends SettingsEvent {
  final AppThemePreference theme;
  const UpdateThemePreferenceEvent(this.theme);

  @override
  List<Object?> get props => [theme];
}

class UpdateCurrencyEvent extends SettingsEvent {
  final String code;
  final String symbol;
  const UpdateCurrencyEvent({required this.code, required this.symbol});

  @override
  List<Object?> get props => [code, symbol];
}

class UpdateLanguageEvent extends SettingsEvent {
  final String languageCode;
  const UpdateLanguageEvent(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class TogglePinLockEvent extends SettingsEvent {
  final bool enabled;
  final String? pin;
  const TogglePinLockEvent({required this.enabled, this.pin});

  @override
  List<Object?> get props => [enabled, pin];
}

class ToggleBiometricsEvent extends SettingsEvent {
  final bool enabled;
  const ToggleBiometricsEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class ExportBackupJsonEvent extends SettingsEvent {
  const ExportBackupJsonEvent();
}

class RestoreBackupJsonEvent extends SettingsEvent {
  const RestoreBackupJsonEvent();
}

class ExportTransactionsCsvEvent extends SettingsEvent {
  const ExportTransactionsCsvEvent();
}
