import 'package:dhanra_new/features/notifications/domain/entities/notification_settings_entity.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitialState extends NotificationsState {
  const NotificationsInitialState();
}

class NotificationsLoadingState extends NotificationsState {
  const NotificationsLoadingState();
}

class NotificationsLoadedState extends NotificationsState {
  final NotificationSettingsEntity settings;
  final bool isPermissionGranted;
  final String? message;

  const NotificationsLoadedState({
    required this.settings,
    required this.isPermissionGranted,
    this.message,
  });

  NotificationsLoadedState copyWith({
    NotificationSettingsEntity? settings,
    bool? isPermissionGranted,
    String? message,
  }) {
    return NotificationsLoadedState(
      settings: settings ?? this.settings,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      message: message,
    );
  }

  @override
  List<Object?> get props => [settings, isPermissionGranted, message];
}

class NotificationsErrorState extends NotificationsState {
  final String errorMessage;

  const NotificationsErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
