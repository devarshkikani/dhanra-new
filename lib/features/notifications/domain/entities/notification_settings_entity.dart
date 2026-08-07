import 'package:equatable/equatable.dart';

class NotificationSettingsEntity extends Equatable {
  final bool enableBudgetAlerts;
  final bool enableGoalReminders;
  final bool enableDailyExpenseReminder;
  final int dailyReminderHour;
  final int dailyReminderMinute;

  const NotificationSettingsEntity({
    this.enableBudgetAlerts = true,
    this.enableGoalReminders = true,
    this.enableDailyExpenseReminder = true,
    this.dailyReminderHour = 20, // Default 8:00 PM
    this.dailyReminderMinute = 0,
  });

  NotificationSettingsEntity copyWith({
    bool? enableBudgetAlerts,
    bool? enableGoalReminders,
    bool? enableDailyExpenseReminder,
    int? dailyReminderHour,
    int? dailyReminderMinute,
  }) {
    return NotificationSettingsEntity(
      enableBudgetAlerts: enableBudgetAlerts ?? this.enableBudgetAlerts,
      enableGoalReminders: enableGoalReminders ?? this.enableGoalReminders,
      enableDailyExpenseReminder:
          enableDailyExpenseReminder ?? this.enableDailyExpenseReminder,
      dailyReminderHour: dailyReminderHour ?? this.dailyReminderHour,
      dailyReminderMinute: dailyReminderMinute ?? this.dailyReminderMinute,
    );
  }

  @override
  List<Object?> get props => [
        enableBudgetAlerts,
        enableGoalReminders,
        enableDailyExpenseReminder,
        dailyReminderHour,
        dailyReminderMinute,
      ];
}
