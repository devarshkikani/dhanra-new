import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/theme/app_typography.dart';
import 'package:dhanra_new/core/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AboutPrivacyPage extends StatelessWidget {
  const AboutPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const AppAppBar(
          title: 'About & Legal',
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingMD,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo & App Build Metadata
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/dhanra.png',
                        height: 36,
                        errorBuilder: (_, __, ___) => const Text(
                          'Dhanra',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      AppSpacing.vGapXS,
                      Text(
                        'Version 1.0.0 (Build 1)',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      AppSpacing.vGapXXS,
                      Text(
                        'AI-Powered Personal Finance & Expense Tracker',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                AppSpacing.vGapLG,

                Text(
                  'Legal & Information',
                  style: AppTypography.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSpacing.vGapSM,

                // Privacy Policy Tile
                _buildLegalTile(
                  icon: Icons.privacy_tip_rounded,
                  color: AppColors.secondary,
                  title: 'Privacy Policy',
                  subtitle: 'Learn how your financial data is kept private & offline on device',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppColors.darkCard,
                        title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
                        content: const SingleChildScrollView(
                          child: Text(
                            'Dhanra values your financial privacy. All SMS logs, account balances, and transaction history remain locally stored and encrypted on your device. No financial records are harvested or sold to third-party advertisers.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Close', style: TextStyle(color: AppColors.primary)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                AppSpacing.vGapXS,

                // Terms of Service Tile
                _buildLegalTile(
                  icon: Icons.gavel_rounded,
                  color: AppColors.primary,
                  title: 'Terms of Service',
                  subtitle: 'Application terms, conditions, and disclaimer details',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppColors.darkCard,
                        title: const Text('Terms of Service', style: TextStyle(color: Colors.white)),
                        content: const SingleChildScrollView(
                          child: Text(
                            'By using Dhanra, you agree that financial calculations, budget limits, and AI summaries are for informational management purposes. Always double-check bank statements for official accounting.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Close', style: TextStyle(color: AppColors.primary)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                AppSpacing.vGapXS,

                // Open Source Licenses Tile
                _buildLegalTile(
                  icon: Icons.code_rounded,
                  color: AppColors.accent,
                  title: 'Open Source Licenses',
                  subtitle: 'Third-party Flutter packages & software attribution',
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: 'Dhanra',
                    applicationVersion: '1.0.0',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegalTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AppCard(
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
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
