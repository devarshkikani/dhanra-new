import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@lazySingleton
class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initSettings);

    // Create Notification Channels for Android
    const androidBudgetChannel = AndroidNotificationChannel(
      'budget_alerts_channel',
      'Budget Alerts',
      description: 'Notifications when category budget caps are reached or exceeded',
      importance: Importance.high,
    );

    const androidGoalChannel = AndroidNotificationChannel(
      'goal_reminders_channel',
      'Goal Reminders',
      description: 'Notifications for savings goal progress and target deadlines',
      importance: Importance.defaultImportance,
    );

    const androidDailyChannel = AndroidNotificationChannel(
      'daily_reminders_channel',
      'Daily Expense Reminders',
      description: 'Scheduled daily reminders to log your daily expenses',
      importance: Importance.high,
    );

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(androidBudgetChannel);
      await androidImplementation.createNotificationChannel(androidGoalChannel);
      await androidImplementation.createNotificationChannel(androidDailyChannel);
    }

    _isInitialized = true;
  }

  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<bool> isPermissionGranted() async {
    return await Permission.notification.isGranted;
  }

  Future<void> showBudgetAlertNotification({
    required String categoryName,
    required double spent,
    required double cap,
    required double percentage,
  }) async {
    await init();
    const androidDetails = AndroidNotificationDetails(
      'budget_alerts_channel',
      'Budget Alerts',
      channelDescription: 'Notifications when category budget caps are reached',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final isExceeded = spent >= cap;
    final title = isExceeded
        ? '⚠️ Budget Exceeded: $categoryName'
        : '⚡ Budget Cap Warning: $categoryName (${percentage.toStringAsFixed(0)}%)';
    final body = isExceeded
        ? 'You spent ₹${spent.toStringAsFixed(2)}, exceeding your ₹${cap.toStringAsFixed(2)} cap.'
        : 'You spent ₹${spent.toStringAsFixed(2)} out of ₹${cap.toStringAsFixed(2)} cap.';

    await _notificationsPlugin.show(
      categoryName.hashCode,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> showGoalReminderNotification({
    required String goalTitle,
    required double currentAmount,
    required double targetAmount,
  }) async {
    await init();
    const androidDetails = AndroidNotificationDetails(
      'goal_reminders_channel',
      'Goal Reminders',
      channelDescription: 'Notifications for savings goal progress',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final progress = (currentAmount / targetAmount * 100).clamp(0.0, 100.0);
    final title = '🎯 Savings Goal Progress: $goalTitle';
    final body =
        'You have saved ₹${currentAmount.toStringAsFixed(2)} (${progress.toStringAsFixed(0)}% of ₹${targetAmount.toStringAsFixed(2)}). Keep it up!';

    await _notificationsPlugin.show(
      goalTitle.hashCode,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> scheduleDailyExpenseReminder({
    required int hour,
    required int minute,
  }) async {
    await init();

    const androidDetails = AndroidNotificationDetails(
      'daily_reminders_channel',
      'Daily Expense Reminders',
      channelDescription: 'Scheduled daily reminders to log expenses',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.cancel(88888); // Unique ID for daily reminder

    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    await _notificationsPlugin.zonedSchedule(
      88888,
      '📝 Daily Expense Tracker',
      'Did you spend anything today? Log your transactions in Dhanra now!',
      tzScheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyExpenseReminder() async {
    await _notificationsPlugin.cancel(88888);
  }

  Future<void> sendTestNotification() async {
    await init();
    const androidDetails = AndroidNotificationDetails(
      'daily_reminders_channel',
      'Daily Expense Reminders',
      channelDescription: 'Test notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      99999,
      '🔔 Dhanra Notifications Active',
      'Local notifications are configured and working properly!',
      notificationDetails,
    );
  }
}
