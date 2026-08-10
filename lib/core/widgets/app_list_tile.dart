import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.darkCard,
        borderRadius: AppRadius.borderMD,
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.borderMD,
        child: ListTile(
          onTap: onTap,
          splashColor: AppColors.primary.withValues(alpha: 0.18),
          // highlightColor: AppColors.primary.withValues(alpha: 0.08),
          hoverColor: AppColors.primary.withValues(alpha: 0.08),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMD),
          leading: leading,
          title: Text(
            title,
            style: AppTypography.titleMedium
                .copyWith(color: AppColors.textPrimary),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                )
              : null,
          trailing: trailing,
        ),
      ),
    );
  }
}
