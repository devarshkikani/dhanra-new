import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_button.dart';

class AppErrorState extends StatelessWidget {
  final String title;
  final String errorMessage;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    this.title = 'Something Went Wrong',
    required this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingLG,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: AppSpacing.paddingMD,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 44,
                color: AppColors.error,
              ),
            ),
            AppSpacing.vGapMD,
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vGapXS,
            Text(
              errorMessage,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              AppSpacing.vGapLG,
              AppButton(
                title: 'Try Again',
                onPressed: onRetry,
                icon: Icons.refresh_rounded,
                width: 160,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
