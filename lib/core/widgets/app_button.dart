import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum AppButtonVariant { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.title,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    Color getBackgroundColor() {
      if (onPressed == null || isLoading) return AppColors.buttonDisabled;
      switch (variant) {
        case AppButtonVariant.primary:
          return AppColors.primary;
        case AppButtonVariant.secondary:
          return AppColors.buttonSecondary;
        case AppButtonVariant.outline:
        case AppButtonVariant.text:
          return Colors.transparent;
      }
    }

    Color getForegroundColor() {
      if (onPressed == null) return AppColors.textMuted;
      switch (variant) {
        case AppButtonVariant.primary:
          return Colors.white;
        case AppButtonVariant.secondary:
          return AppColors.textPrimary;
        case AppButtonVariant.outline:
          return AppColors.primary;
        case AppButtonVariant.text:
          return AppColors.secondary;
      }
    }

    BorderSide getBorder() {
      if (variant == AppButtonVariant.outline) {
        return BorderSide(
          color: onPressed == null ? AppColors.inputBorder : AppColors.primary,
          width: 1.5,
        );
      }
      return BorderSide.none;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: getBackgroundColor(),
          foregroundColor: getForegroundColor(),
          elevation: variant == AppButtonVariant.primary ? 4 : 0,
          shadowColor: AppColors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderMD,
            side: getBorder(),
          ),
          padding: AppSpacing.paddingHorizontalMD,
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(getForegroundColor()),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: getForegroundColor()),
                    AppSpacing.hGapXS,
                  ],
                  Text(
                    title,
                    style: AppTypography.labelLarge.copyWith(
                      color: getForegroundColor(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
