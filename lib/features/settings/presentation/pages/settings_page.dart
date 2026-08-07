import 'package:dhanra_new/core/router/app_router.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/theme/app_typography.dart';
import 'package:dhanra_new/core/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: const AppAppBar(
        title: 'Settings & Configuration',
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
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

              // 2. Preferences & Configuration
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
              AppSpacing.vGapXS,

              _buildSettingsTile(
                context: context,
                icon: Icons.auto_awesome_rounded,
                color: AppColors.accent,
                title: 'AI Financial Assistant',
                subtitle:
                    'Configure smart insight predictions & subscription detection',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('AI Financial Assistant active'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
              ),
              AppSpacing.vGapLG,

              // 3. App Settings
              Text(
                'App Settings & Security',
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.vGapSM,

              _buildSettingsTile(
                context: context,
                icon: Icons.lock_outline_rounded,
                color: AppColors.credit,
                title: 'Security & App Lock',
                subtitle: 'Enable PIN lock and biometric authentication',
                onTap: () {},
              ),
              AppSpacing.vGapXS,

              _buildSettingsTile(
                context: context,
                icon: Icons.notifications_none_rounded,
                color: AppColors.primary,
                title: 'Notifications & Alerts',
                subtitle:
                    'Bill payment reminders & budget alert notifications',
                onTap: () {},
              ),
              AppSpacing.vGapXS,

              _buildSettingsTile(
                context: context,
                icon: Icons.download_rounded,
                color: AppColors.secondary,
                title: 'Export Financial Data',
                subtitle:
                    'Export transactions and accounts as CSV or PDF report',
                onTap: () {},
              ),
            ],
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
