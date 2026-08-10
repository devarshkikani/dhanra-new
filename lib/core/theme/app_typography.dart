import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Single source of truth for typography hierarchy tokens in Dhanra.
///
/// Typography Division Rules:
/// - SK Modernist (Large Headers Only): Used for headers >= 18px (balance numbers, hero titles, onboarding headers).
/// - Geist (All Body and Data): Used for body text, lists, input fields, dates & tags < 18px.
abstract class AppTypography {
  /// Font family for headers >= 18px
  static const String fontHeader = 'SK Modernist';

  /// Font family for body and data < 18px
  static const String fontBody = 'Geist';

  // Display Styles (>= 18px -> SK Modernist)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontHeader,
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontHeader,
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontHeader,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Headline Styles (>= 18px -> SK Modernist)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontHeader,
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontHeader,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontHeader,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Title Styles (< 18px -> Geist)
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontBody,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontBody,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontBody,
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  // Body Styles (< 18px -> Geist)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontBody,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontBody,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontBody,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // Label & Action Styles (< 18px -> Geist)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontBody,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontBody,
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontBody,
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
  );
}
