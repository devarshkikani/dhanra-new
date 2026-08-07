import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_button.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final String primaryButtonText;
  final VoidCallback onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;
  final IconData? icon;

  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    required this.primaryButtonText,
    required this.onPrimaryPressed,
    this.secondaryButtonText,
    this.onSecondaryPressed,
    this.icon,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required String primaryButtonText,
    required VoidCallback onPrimaryPressed,
    String? secondaryButtonText,
    VoidCallback? onSecondaryPressed,
    IconData? icon,
  }) {
    return showDialog(
      context: context,
      builder: (_) => AppDialog(
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        secondaryButtonText: secondaryButtonText,
        onSecondaryPressed: onSecondaryPressed,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.darkCard,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXL),
      child: Padding(
        padding: AppSpacing.paddingLG,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Container(
                padding: AppSpacing.paddingMD,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 36),
              ),
              AppSpacing.vGapMD,
            ],
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vGapSM,
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vGapLG,
            Row(
              children: [
                if (secondaryButtonText != null) ...[
                  Expanded(
                    child: AppButton(
                      title: secondaryButtonText!,
                      variant: AppButtonVariant.outline,
                      onPressed: onSecondaryPressed ?? () => Navigator.of(context).pop(),
                    ),
                  ),
                  AppSpacing.hGapSM,
                ],
                Expanded(
                  child: AppButton(
                    title: primaryButtonText,
                    onPressed: () {
                      Navigator.of(context).pop();
                      onPrimaryPressed();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
