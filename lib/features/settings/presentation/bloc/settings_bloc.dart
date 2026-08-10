import 'package:dhanra_new/core/services/backup_export_service.dart';
import 'package:dhanra_new/core/services/security_service.dart';
import 'package:dhanra_new/features/settings/data/datasources/app_settings_local_data_source.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_event.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppSettingsLocalDataSource dataSource;
  final SecurityService securityService;
  final BackupExportService backupExportService;

  SettingsBloc({
    required this.dataSource,
    required this.securityService,
    required this.backupExportService,
  }) : super(const SettingsInitialState()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateThemePreferenceEvent>(_onUpdateTheme);
    on<UpdateCurrencyEvent>(_onUpdateCurrency);
    on<UpdateLanguageEvent>(_onUpdateLanguage);
    on<TogglePinLockEvent>(_onTogglePinLock);
    on<ToggleBiometricsEvent>(_onToggleBiometrics);
    on<ExportBackupJsonEvent>(_onExportBackup);
    on<RestoreBackupJsonEvent>(_onRestoreBackup);
    on<ExportTransactionsCsvEvent>(_onExportCsv);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoadingState());
    try {
      final settings = dataSource.getSettings();
      final isBioSupported = await securityService.isBiometricsSupported();
      emit(SettingsLoadedState(
        settings: settings,
        isBiometricsSupported: isBioSupported,
      ));
    } catch (e) {
      emit(SettingsErrorState('Failed to load settings: $e'));
    }
  }

  Future<void> _onUpdateTheme(
    UpdateThemePreferenceEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoadedState) {
      final current = state as SettingsLoadedState;
      final updated = current.settings.copyWith(themePreference: event.theme);
      await dataSource.saveSettings(updated);
      emit(current.copyWith(settings: updated, successMessage: 'Theme updated'));
    }
  }

  Future<void> _onUpdateCurrency(
    UpdateCurrencyEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoadedState) {
      final current = state as SettingsLoadedState;
      final updated = current.settings.copyWith(
        currencyCode: event.code,
        currencySymbol: event.symbol,
      );
      await dataSource.saveSettings(updated);
      emit(current.copyWith(settings: updated, successMessage: 'Currency updated to ${event.code} (${event.symbol})'));
    }
  }

  Future<void> _onUpdateLanguage(
    UpdateLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoadedState) {
      final current = state as SettingsLoadedState;
      final updated = current.settings.copyWith(languageCode: event.languageCode);
      await dataSource.saveSettings(updated);
      emit(current.copyWith(settings: updated, successMessage: 'Language updated'));
    }
  }

  Future<void> _onTogglePinLock(
    TogglePinLockEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoadedState) {
      final current = state as SettingsLoadedState;
      final updated = current.settings.copyWith(
        isPinLockEnabled: event.enabled,
        pinCode: event.pin,
      );
      await dataSource.saveSettings(updated);
      emit(current.copyWith(
        settings: updated,
        successMessage: event.enabled ? 'PIN Security Enabled' : 'PIN Security Disabled',
      ));
    }
  }

  Future<void> _onToggleBiometrics(
    ToggleBiometricsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoadedState) {
      final current = state as SettingsLoadedState;
      if (event.enabled) {
        final authenticated = await securityService.authenticateWithBiometrics(
          reason: 'Authenticate to enable biometric app lock',
        );
        if (!authenticated) {
          emit(current.copyWith(successMessage: 'Biometric authentication failed.'));
          return;
        }
      }
      final updated = current.settings.copyWith(isBiometricEnabled: event.enabled);
      await dataSource.saveSettings(updated);
      emit(current.copyWith(
        settings: updated,
        successMessage: event.enabled ? 'Biometric App Lock Enabled' : 'Biometric App Lock Disabled',
      ));
    }
  }

  Future<void> _onExportBackup(
    ExportBackupJsonEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoadedState) {
      final current = state as SettingsLoadedState;
      emit(current.copyWith(isExporting: true));
      try {
        await backupExportService.exportJsonBackup();
        emit(current.copyWith(isExporting: false, successMessage: 'JSON Backup created successfully.'));
      } catch (e) {
        emit(current.copyWith(isExporting: false, successMessage: 'Export failed: $e'));
      }
    }
  }

  Future<void> _onRestoreBackup(
    RestoreBackupJsonEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoadedState) {
      final current = state as SettingsLoadedState;
      emit(current.copyWith(isExporting: true));
      try {
        final success = await backupExportService.restoreJsonBackup();
        emit(current.copyWith(
          isExporting: false,
          successMessage: success ? 'Backup file selected & verified.' : 'Restore cancelled.',
        ));
      } catch (e) {
        emit(current.copyWith(isExporting: false, successMessage: 'Restore failed: $e'));
      }
    }
  }

  Future<void> _onExportCsv(
    ExportTransactionsCsvEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoadedState) {
      final current = state as SettingsLoadedState;
      emit(current.copyWith(isExporting: true));
      try {
        await backupExportService.exportTransactionsCsv();
        emit(current.copyWith(isExporting: false, successMessage: 'Transactions exported to CSV.'));
      } catch (e) {
        emit(current.copyWith(isExporting: false, successMessage: 'CSV Export failed: $e'));
      }
    }
  }
}
