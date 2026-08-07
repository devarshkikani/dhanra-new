import 'package:equatable/equatable.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotificationSettingsEvent extends NotificationsEvent {
  const LoadNotificationSettingsEvent();
}

class ToggleBudgetAlertsEvent extends NotificationsEvent {
  final bool enabled;
  const ToggleBudgetAlertsEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class ToggleGoalRemindersEvent extends NotificationsEvent {
  final bool enabled;
  const ToggleGoalRemindersEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class ToggleDailyReminderEvent extends NotificationsEvent {
  final bool enabled;
  const ToggleDailyReminderEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class UpdateDailyReminderTimeEvent extends NotificationsEvent {
  final int hour;
  final int minute;
  const UpdateDailyReminderTimeEvent(this.hour, this.minute);

  @override
  List<Object?> get props => [hour, minute];
}

class SendTestNotificationEvent extends NotificationsEvent {
  const SendTestNotificationEvent();
}

class RequestNotificationPermissionEvent extends NotificationsEvent {
  const RequestNotificationPermissionEvent();
}
