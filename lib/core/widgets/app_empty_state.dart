import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_button.dart';

class AppEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onAction;
  final String? imagePath;
  final IconData? icon;

  const AppEmptyState({
    super.key,
    this.title = 'No Data Found',
    this.message = 'There are no items to display right now.',
    this.buttonText,
    this.onAction,
    this.imagePath,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingLG,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null) ...[
              Image.asset(
                imagePath!,
                height: 140,
                fit: BoxFit.contain,
              ),
              AppSpacing.vGapMD,
            ] else if (icon != null) ...[
              Container(
                padding: AppSpacing.paddingMD,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              AppSpacing.vGapMD,
            ] else ...[
              Image.asset(
                'assets/images/empty_transactions.png',
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.inbox_rounded,
                  size: 48,
                  color: AppColors.textSecondary,
                ),
              ),
              AppSpacing.vGapMD,
            ],
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vGapXS,
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onAction != null) ...[
              AppSpacing.vGapLG,
              AppButton(
                title: buttonText!,
                onPressed: onAction,
                width: 180,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
