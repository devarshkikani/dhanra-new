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

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: const AppAppBar(
        title: 'Theme & Appearance',
      ),
      body: SafeArea(
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoadedState) {
              final currentTheme = state.settings.themePreference;

              return Padding(
                padding: AppSpacing.paddingMD,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Theme Mode',
                      style: AppTypography.labelSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppSpacing.vGapSM,
                    _buildThemeTile(
                      context: context,
                      title: 'Dark Mode (OLED Slate)',
                      subtitle: 'Sleek dark theme optimized for OLED screens',
                      icon: Icons.dark_mode_rounded,
                      value: AppThemePreference.dark,
                      groupValue: currentTheme,
                    ),
                    AppSpacing.vGapXS,
                    _buildThemeTile(
                      context: context,
                      title: 'System Default',
                      subtitle: 'Match system dark/light appearance setting',
                      icon: Icons.brightness_auto_rounded,
                      value: AppThemePreference.system,
                      groupValue: currentTheme,
                    ),
                    AppSpacing.vGapXS,
                    _buildThemeTile(
                      context: context,
                      title: 'Light Mode',
                      subtitle: 'Clean high contrast bright theme',
                      icon: Icons.light_mode_rounded,
                      value: AppThemePreference.light,
                      groupValue: currentTheme,
                    ),
                  ],
                ),
              );
            }

            return const AppLoading(message: 'Loading theme settings...');
          },
        ),
      ),
    );
  }

  Widget _buildThemeTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required AppThemePreference value,
    required AppThemePreference groupValue,
  }) {
    final isSelected = value == groupValue;

    return AppCard(
      variant: isSelected ? AppCardVariant.hero : AppCardVariant.standard,
      padding: AppSpacing.paddingMD,
      onTap: () {
        context.read<SettingsBloc>().add(UpdateThemePreferenceEvent(value));
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : AppColors.darkSurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 22,
            ),
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
          Radio<AppThemePreference>(
            value: value,
            groupValue: groupValue,
            activeColor: AppColors.primary,
            onChanged: (val) {
              if (val != null) {
                context.read<SettingsBloc>().add(UpdateThemePreferenceEvent(val));
              }
            },
          ),
        ],
      ),
    );
  }
}
