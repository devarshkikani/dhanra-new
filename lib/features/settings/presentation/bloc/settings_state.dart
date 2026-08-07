import 'package:dhanra_new/features/settings/domain/entities/app_settings_entity.dart';
import 'package:equatable/equatable.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitialState extends SettingsState {
  const SettingsInitialState();
}

class SettingsLoadingState extends SettingsState {
  const SettingsLoadingState();
}

class SettingsLoadedState extends SettingsState {
  final AppSettingsEntity settings;
  final bool isBiometricsSupported;
  final String? successMessage;
  final bool isExporting;

  const SettingsLoadedState({
    required this.settings,
    required this.isBiometricsSupported,
    this.successMessage,
    this.isExporting = false,
  });

  SettingsLoadedState copyWith({
    AppSettingsEntity? settings,
    bool? isBiometricsSupported,
    String? successMessage,
    bool? isExporting,
  }) {
    return SettingsLoadedState(
      settings: settings ?? this.settings,
      isBiometricsSupported: isBiometricsSupported ?? this.isBiometricsSupported,
      successMessage: successMessage,
      isExporting: isExporting ?? this.isExporting,
    );
  }

  @override
  List<Object?> get props => [
        settings,
        isBiometricsSupported,
        successMessage,
        isExporting,
      ];
}

class SettingsErrorState extends SettingsState {
  final String errorMessage;

  const SettingsErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
