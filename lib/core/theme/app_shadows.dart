import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Single source of truth for shadow and elevation tokens in Dhanra.
abstract class AppShadows {
  static const BoxShadow sm = BoxShadow(
    color: AppColors.shadow,
    blurRadius: 4.0,
    offset: Offset(0, 2),
  );

  static const BoxShadow md = BoxShadow(
    color: AppColors.shadow,
    blurRadius: 8.0,
    offset: Offset(0, 4),
  );

  static const BoxShadow lg = BoxShadow(
    color: AppColors.shadow,
    blurRadius: 16.0,
    offset: Offset(0, 8),
  );

  static final BoxShadow primaryGlow = BoxShadow(
    color: AppColors.primary.withValues(alpha: 0.35),
    blurRadius: 20.0,
    spreadRadius: 2.0,
    offset: const Offset(0, 4),
  );

  static final BoxShadow secondaryGlow = BoxShadow(
    color: AppColors.secondary.withValues(alpha: 0.35),
    blurRadius: 20.0,
    spreadRadius: 2.0,
    offset: const Offset(0, 4),
  );
}
