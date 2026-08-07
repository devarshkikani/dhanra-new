import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

enum AppCardVariant { standard, glass, outlined, hero }

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final AppCardVariant variant;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.variant = AppCardVariant.standard,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    BoxDecoration getDecoration() {
      final effectiveRadius = borderRadius ?? AppRadius.borderLG;
      switch (variant) {
        case AppCardVariant.glass:
          return BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: effectiveRadius,
            border: Border.all(color: AppColors.glassBorder),
          );
        case AppCardVariant.outlined:
          return BoxDecoration(
            color: backgroundColor ?? AppColors.darkSurface,
            borderRadius: effectiveRadius,
            border: Border.all(color: AppColors.inputBorder),
          );
        case AppCardVariant.hero:
          return BoxDecoration(
            color: backgroundColor ?? AppColors.darkCard,
            borderRadius: effectiveRadius,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
          );
        case AppCardVariant.standard:
        default:
          return BoxDecoration(
            color: backgroundColor ?? AppColors.darkCard,
            borderRadius: effectiveRadius,
            border: Border.all(color: AppColors.glassBorder),
          );
      }
    }

    final cardWidget = Container(
      decoration: getDecoration(),
      padding: padding ?? AppSpacing.paddingMD,
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? AppRadius.borderLG,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}
