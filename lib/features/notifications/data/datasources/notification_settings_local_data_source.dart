import 'package:dhanra_new/features/notifications/domain/entities/notification_settings_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class NotificationSettingsLocalDataSource {
  static const String _keyBudgetAlerts = 'notif_budget_alerts';
  static const String _keyGoalReminders = 'notif_goal_reminders';
  static const String _keyDailyReminder = 'notif_daily_reminder';
  static const String _keyDailyHour = 'notif_daily_hour';
  static const String _keyDailyMinute = 'notif_daily_minute';

  final SharedPreferences _prefs;

  NotificationSettingsLocalDataSource(this._prefs);

  NotificationSettingsEntity getSettings() {
    final enableBudgetAlerts = _prefs.getBool(_keyBudgetAlerts) ?? true;
    final enableGoalReminders = _prefs.getBool(_keyGoalReminders) ?? true;
    final enableDailyExpenseReminder = _prefs.getBool(_keyDailyReminder) ?? true;
    final dailyReminderHour = _prefs.getInt(_keyDailyHour) ?? 20;
    final dailyReminderMinute = _prefs.getInt(_keyDailyMinute) ?? 0;

    return NotificationSettingsEntity(
      enableBudgetAlerts: enableBudgetAlerts,
      enableGoalReminders: enableGoalReminders,
      enableDailyExpenseReminder: enableDailyExpenseReminder,
      dailyReminderHour: dailyReminderHour,
      dailyReminderMinute: dailyReminderMinute,
    );
  }

  Future<void> saveSettings(NotificationSettingsEntity settings) async {
    await _prefs.setBool(_keyBudgetAlerts, settings.enableBudgetAlerts);
    await _prefs.setBool(_keyGoalReminders, settings.enableGoalReminders);
    await _prefs.setBool(_keyDailyReminder, settings.enableDailyExpenseReminder);
    await _prefs.setInt(_keyDailyHour, settings.dailyReminderHour);
    await _prefs.setInt(_keyDailyMinute, settings.dailyReminderMinute);
  }
}
