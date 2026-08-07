import 'package:dhanra_new/core/services/notification_service.dart';
import 'package:dhanra_new/features/notifications/data/datasources/notification_settings_local_data_source.dart';
import 'package:dhanra_new/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:dhanra_new/features/notifications/presentation/bloc/notifications_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationSettingsLocalDataSource dataSource;
  final NotificationService notificationService;

  NotificationsBloc({
    required this.dataSource,
    required this.notificationService,
  }) : super(const NotificationsInitialState()) {
    on<LoadNotificationSettingsEvent>(_onLoadSettings);
    on<ToggleBudgetAlertsEvent>(_onToggleBudgetAlerts);
    on<ToggleGoalRemindersEvent>(_onToggleGoalReminders);
    on<ToggleDailyReminderEvent>(_onToggleDailyReminder);
    on<UpdateDailyReminderTimeEvent>(_onUpdateDailyReminderTime);
    on<SendTestNotificationEvent>(_onSendTestNotification);
    on<RequestNotificationPermissionEvent>(_onRequestPermission);
  }

  Future<void> _onLoadSettings(
    LoadNotificationSettingsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsLoadingState());
    try {
      await notificationService.init();
      final settings = dataSource.getSettings();
      final isGranted = await notificationService.isPermissionGranted();

      if (settings.enableDailyExpenseReminder && isGranted) {
        await notificationService.scheduleDailyExpenseReminder(
          hour: settings.dailyReminderHour,
          minute: settings.dailyReminderMinute,
        );
      }

      emit(NotificationsLoadedState(
        settings: settings,
        isPermissionGranted: isGranted,
      ));
    } catch (e) {
      emit(NotificationsErrorState('Failed to load notification settings: $e'));
    }
  }

  Future<void> _onToggleBudgetAlerts(
    ToggleBudgetAlertsEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoadedState) {
      final current = (state as NotificationsLoadedState);
      final updatedSettings = current.settings.copyWith(enableBudgetAlerts: event.enabled);
      await dataSource.saveSettings(updatedSettings);
      emit(current.copyWith(settings: updatedSettings));
    }
  }

  Future<void> _onToggleGoalReminders(
    ToggleGoalRemindersEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoadedState) {
      final current = (state as NotificationsLoadedState);
      final updatedSettings = current.settings.copyWith(enableGoalReminders: event.enabled);
      await dataSource.saveSettings(updatedSettings);
      emit(current.copyWith(settings: updatedSettings));
    }
  }

  Future<void> _onToggleDailyReminder(
    ToggleDailyReminderEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoadedState) {
      final current = (state as NotificationsLoadedState);
      final updatedSettings = current.settings.copyWith(enableDailyExpenseReminder: event.enabled);
      await dataSource.saveSettings(updatedSettings);

      if (event.enabled) {
        await notificationService.scheduleDailyExpenseReminder(
          hour: updatedSettings.dailyReminderHour,
          minute: updatedSettings.dailyReminderMinute,
        );
      } else {
        await notificationService.cancelDailyExpenseReminder();
      }

      emit(current.copyWith(settings: updatedSettings));
    }
  }

  Future<void> _onUpdateDailyReminderTime(
    UpdateDailyReminderTimeEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoadedState) {
      final current = (state as NotificationsLoadedState);
      final updatedSettings = current.settings.copyWith(
        dailyReminderHour: event.hour,
        dailyReminderMinute: event.minute,
      );
      await dataSource.saveSettings(updatedSettings);

      if (updatedSettings.enableDailyExpenseReminder) {
        await notificationService.scheduleDailyExpenseReminder(
          hour: event.hour,
          minute: event.minute,
        );
      }

      emit(current.copyWith(settings: updatedSettings));
    }
  }

  Future<void> _onSendTestNotification(
    SendTestNotificationEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoadedState) {
      final current = (state as NotificationsLoadedState);
      await notificationService.sendTestNotification();
      emit(current.copyWith(message: 'Test notification sent successfully!'));
    }
  }

  Future<void> _onRequestPermission(
    RequestNotificationPermissionEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoadedState) {
      final current = (state as NotificationsLoadedState);
      final granted = await notificationService.requestPermission();
      emit(current.copyWith(isPermissionGranted: granted));
    }
  }
}
