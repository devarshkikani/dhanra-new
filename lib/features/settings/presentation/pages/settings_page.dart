import 'package:dhanra_new/core/common_widgets/glass_card.dart';
import 'package:dhanra_new/core/router/app_router.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_gradients.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Settings & Configuration'),
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.backgroundGlow,
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 110,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. User Profile Header Card
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  borderRadius: 22,
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          gradient: AppGradients.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'DD',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Don Daniel',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'don.daniel@dhanra.app',
                              style: TextStyle(
                                fontSize: 13,
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
                          color: AppColors.secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Pro Member',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Preferences & Configuration
                const Text(
                  'Preferences & Management',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                // Category Management Tile
                _buildSettingsTile(
                  context: context,
                  icon: Icons.category_rounded,
                  color: AppColors.primary,
                  title: 'Category Management',
                  subtitle:
                      'Manage income & expense categories, sub-categories, icons & colors',
                  onTap: () => context.push(AppRoutes.categories),
                ),
                const SizedBox(height: 10),

                // Budget Management Shortcut Tile
                _buildSettingsTile(
                  context: context,
                  icon: Icons.pie_chart_rounded,
                  color: AppColors.secondary,
                  title: 'Budget Limits & Warnings',
                  subtitle:
                      'Configure monthly category caps & warning thresholds',
                  onTap: () => context.push(AppRoutes.budgets),
                ),
                const SizedBox(height: 10),

                // AI Financial Assistant Settings Tile
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
                            Text('AI Financial Assistant coming in Phase 12'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // 3. App Settings
                const Text(
                  'App Settings & Security',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                _buildSettingsTile(
                  context: context,
                  icon: Icons.lock_outline_rounded,
                  color: AppColors.credit,
                  title: 'Security & App Lock',
                  subtitle: 'Enable PIN lock and biometric authentication',
                  onTap: () {},
                ),
                const SizedBox(height: 10),

                _buildSettingsTile(
                  context: context,
                  icon: Icons.notifications_none_rounded,
                  color: AppColors.primary,
                  title: 'Notifications & Alerts',
                  subtitle:
                      'Bill payment reminders & budget alert notifications',
                  onTap: () {},
                ),
                const SizedBox(height: 10),

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
    return GlassCard(
      borderRadius: 18,
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
