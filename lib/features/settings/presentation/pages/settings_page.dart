import 'package:dhanra_new/core/di/injection.dart';
import 'package:dhanra_new/core/router/app_router.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/theme/app_typography.dart';
import 'package:dhanra_new/core/widgets/widgets.dart';
import 'package:dhanra_new/features/settings/domain/entities/app_settings_entity.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_event.dart';
import 'package:dhanra_new/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (_) => getIt<SettingsBloc>()..add(const LoadSettingsEvent()),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        appBar: const AppAppBar(
          title: 'Settings & Configuration',
        ),
        body: SafeArea(
          bottom: false,
          child: BlocConsumer<SettingsBloc, SettingsState>(
            listener: (context, state) {
              if (state is SettingsLoadedState && state.successMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.successMessage!),
                    backgroundColor: AppColors.primary,
                  ),
                );
              }
            },
            builder: (context, state) {
              final currencySymbol =
                  (state is SettingsLoadedState) ? state.settings.currencySymbol : '₹';
              final currencyCode =
                  (state is SettingsLoadedState) ? state.settings.currencyCode : 'INR';
              final themeName =
                  (state is SettingsLoadedState) ? state.settings.themePreference.displayName : 'Dark Mode';

              return SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  top: AppSpacing.xs,
                  bottom: 110,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. User Profile Header Card
                    AppCard(
                      variant: AppCardVariant.standard,
                      padding: AppSpacing.paddingMD,
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                'DD',
                                style: AppTypography.headlineSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          AppSpacing.hGapMD,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Don Daniel',
                                  style: AppTypography.titleLarge.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                AppSpacing.vGapXXS,
                                Text(
                                  'don.daniel@dhanra.app',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Pro Member',
                              style: AppTypography.labelSmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSpacing.vGapLG,

                    // 2. Financial & Categorization Rules
                    Text(
                      'Preferences & Management',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.vGapSM,

                    _buildSettingsTile(
                      context: context,
                      icon: Icons.category_rounded,
                      color: AppColors.primary,
                      title: 'Category Management',
                      subtitle:
                          'Manage income & expense categories, sub-categories, icons & colors',
                      onTap: () => context.push(AppRoutes.categories),
                    ),
                    AppSpacing.vGapXS,

                    _buildSettingsTile(
                      context: context,
                      icon: Icons.pie_chart_rounded,
                      color: AppColors.secondary,
                      title: 'Budget Limits & Warnings',
                      subtitle:
                          'Configure monthly category caps & warning thresholds',
                      onTap: () => context.push(AppRoutes.budgets),
                    ),
                    AppSpacing.vGapXS,

                    _buildSettingsTile(
                      context: context,
                      icon: Icons.savings_rounded,
                      color: AppColors.credit,
                      title: 'Savings Goals & Milestones',
                      subtitle: 'Manage savings targets, deposit logs & deadlines',
                      onTap: () => context.push(AppRoutes.goals),
                    ),
                    AppSpacing.vGapLG,

                    // 3. System Preferences
                    Text(
                      'System & Appearance',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.vGapSM,

                    _buildSettingsTile(
                      context: context,
                      icon: Icons.palette_rounded,
                      color: AppColors.primary,
                      title: 'Theme & Appearance',
                      subtitle: 'Current: $themeName',
                      onTap: () => context.push(AppRoutes.themeSettings),
                    ),
                    AppSpacing.vGapXS,

                    _buildSettingsTile(
                      context: context,
                      icon: Icons.currency_exchange_rounded,
                      color: AppColors.secondary,
                      title: 'Primary Currency',
                      subtitle: 'Selected: $currencyCode ($currencySymbol)',
                      onTap: () => context.push(AppRoutes.currencySettings),
                    ),
                    AppSpacing.vGapXS,

                    _buildSettingsTile(
                      context: context,
                      icon: Icons.lock_outline_rounded,
                      color: AppColors.credit,
                      title: 'Security & App Lock',
                      subtitle: 'Configure secret PIN lock & biometric authentication',
                      onTap: () => context.push(AppRoutes.securitySettings),
                    ),
                    AppSpacing.vGapXS,

                    _buildSettingsTile(
                      context: context,
                      icon: Icons.notifications_none_rounded,
                      color: AppColors.primary,
                      title: 'Notifications & Alerts',
                      subtitle:
                          'Manage budget alerts, daily expense reminders & goal milestones',
                      onTap: () => context.push(AppRoutes.notifications),
                    ),
                    AppSpacing.vGapLG,

                    // 4. Data Storage & Backup
                    Text(
                      'Data Storage & Legal',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.vGapSM,

                    _buildSettingsTile(
                      context: context,
                      icon: Icons.cloud_sync_rounded,
                      color: AppColors.secondary,
                      title: 'Backup & Restore Data',
                      subtitle: 'Export encrypted JSON snapshot or restore database',
                      onTap: () => context.push(AppRoutes.backupRestore),
                    ),
                    AppSpacing.vGapXS,

                    _buildSettingsTile(
                      context: context,
                      icon: Icons.download_rounded,
                      color: AppColors.credit,
                      title: 'Export Transactions (CSV)',
                      subtitle: 'Export transaction spreadsheet report',
                      onTap: () => context
                          .read<SettingsBloc>()
                          .add(const ExportTransactionsCsvEvent()),
                    ),
                    AppSpacing.vGapXS,

                    _buildSettingsTile(
                      context: context,
                      icon: Icons.info_outline_rounded,
                      color: AppColors.accent,
                      title: 'About & Legal',
                      subtitle: 'App version v1.0.0, privacy policy, and licenses',
                      onTap: () => context.push(AppRoutes.aboutPrivacy),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AppCard(
      variant: AppCardVariant.standard,
      padding: AppSpacing.paddingMD,
      onTap: onTap,
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
          const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
