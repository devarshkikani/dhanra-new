import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/theme/app_typography.dart';
import 'package:dhanra_new/core/widgets/widgets.dart';
import 'package:dhanra_new/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:dhanra_new/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:dhanra_new/features/notifications/presentation/bloc/notifications_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: const AppAppBar(
        title: 'Notifications & Alerts',
      ),
      body: SafeArea(
        child: BlocConsumer<NotificationsBloc, NotificationsState>(
          listener: (context, state) {
            if (state is NotificationsLoadedState && state.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                  backgroundColor: AppColors.primary,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is NotificationsLoadingState ||
                state is NotificationsInitialState) {
              return const AppLoading(message: 'Loading notification settings...');
            }

            if (state is NotificationsErrorState) {
              return AppErrorState(
                errorMessage: state.errorMessage,
                onRetry: () => context
                    .read<NotificationsBloc>()
                    .add(const LoadNotificationSettingsEvent()),
              );
            }

            if (state is NotificationsLoadedState) {
              final settings = state.settings;
              final isPermissionGranted = state.isPermissionGranted;

              final hourStr = settings.dailyReminderHour.toString().padLeft(2, '0');
              final minStr = settings.dailyReminderMinute.toString().padLeft(2, '0');
              final timeFormatted = '$hourStr:$minStr';

              return SingleChildScrollView(
                padding: AppSpacing.paddingMD,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Permission Banner
                    if (!isPermissionGranted) ...[
                      AppCard(
                        variant: AppCardVariant.standard,
                        backgroundColor: AppColors.warning.withValues(alpha: 0.12),
                        padding: AppSpacing.paddingMD,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.notifications_off_rounded,
                              color: AppColors.warning,
                              size: 28,
                            ),
                            AppSpacing.hGapMD,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Notification Permission Disabled',
                                    style: AppTypography.titleMedium.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  AppSpacing.vGapXXS,
                                  Text(
                                    'Enable permissions to receive budget alerts & daily reminders.',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppSpacing.hGapXS,
                            AppButton(
                              title: 'Grant',
                              height: 36,
                              width: 80,
                              onPressed: () => context
                                  .read<NotificationsBloc>()
                                  .add(const RequestNotificationPermissionEvent()),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.vGapLG,
                    ],

                    Text(
                      'Smart Alerts & Reminders',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.vGapSM,

                    // 1. Budget Alerts Toggle
                    _buildSwitchTile(
                      icon: Icons.pie_chart_rounded,
                      color: AppColors.primary,
                      title: 'Budget Threshold Alerts',
                      subtitle:
                          'Notify instantly when spending hits 80% or 100% of category caps',
                      value: settings.enableBudgetAlerts,
                      onChanged: (val) => context
                          .read<NotificationsBloc>()
                          .add(ToggleBudgetAlertsEvent(val)),
                    ),
                    AppSpacing.vGapXS,

                    // 2. Savings Goal Reminders Toggle
                    _buildSwitchTile(
                      icon: Icons.savings_rounded,
                      color: AppColors.credit,
                      title: 'Savings Goal Reminders',
                      subtitle:
                          'Get progress updates on your milestone targets & deadlines',
                      value: settings.enableGoalReminders,
                      onChanged: (val) => context
                          .read<NotificationsBloc>()
                          .add(ToggleGoalRemindersEvent(val)),
                    ),
                    AppSpacing.vGapXS,

                    // 3. Daily Expense Reminder Toggle
                    _buildSwitchTile(
                      icon: Icons.edit_calendar_rounded,
                      color: AppColors.secondary,
                      title: 'Daily Expense Reminder',
                      subtitle:
                          'Scheduled daily reminder at $timeFormatted to log expenses',
                      value: settings.enableDailyExpenseReminder,
                      onChanged: (val) => context
                          .read<NotificationsBloc>()
                          .add(ToggleDailyReminderEvent(val)),
                    ),
                    AppSpacing.vGapXS,

                    // Time Picker for Daily Reminder
                    if (settings.enableDailyExpenseReminder) ...[
                      AppCard(
                        variant: AppCardVariant.standard,
                        padding: AppSpacing.paddingMD,
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: settings.dailyReminderHour,
                              minute: settings.dailyReminderMinute,
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: AppColors.primary,
                                    surface: AppColors.darkCard,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null && context.mounted) {
                            context.read<NotificationsBloc>().add(
                                  UpdateDailyReminderTimeEvent(
                                    picked.hour,
                                    picked.minute,
                                  ),
                                );
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.access_time_rounded,
                                color: AppColors.secondary,
                                size: 20,
                              ),
                            ),
                            AppSpacing.hGapMD,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reminder Time',
                                    style: AppTypography.titleMedium.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  AppSpacing.vGapXXS,
                                  Text(
                                    'Tap to change daily notification time ($timeFormatted)',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              timeFormatted,
                              style: AppTypography.headlineSmall.copyWith(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.vGapLG,
                    ],

                    AppSpacing.vGapLG,

                    // Test Notification Button
                    AppButton(
                      title: 'Send Test Notification',
                      icon: Icons.notifications_active_rounded,
                      variant: AppButtonVariant.outline,
                      onPressed: () => context
                          .read<NotificationsBloc>()
                          .add(const SendTestNotificationEvent()),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return AppCard(
      variant: AppCardVariant.standard,
      padding: AppSpacing.paddingMD,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          AppSpacing.hGapMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.vGapXXS,
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
