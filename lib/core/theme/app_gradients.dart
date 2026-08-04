import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Standard ambient and accent gradients for Dhanra-New UI components.
abstract class AppGradients {
  /// Signature Poli Purple to Electric Mint Cyan gradient
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Deep glass card background gradient
  static LinearGradient glassCard = LinearGradient(
    colors: [
      Colors.white.withValues(alpha: 0.08),
      Colors.white.withValues(alpha: 0.02),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent button glow gradient
  static const LinearGradient accent = LinearGradient(
    colors: [AppColors.accent, AppColors.primary],
  );

  /// Hero Balance Card ambient gradient
  static const LinearGradient heroCard = LinearGradient(
    colors: [
      Color(0xFF1E1035),
      Color(0xFF0F1E25),
      AppColors.darkCard,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle dark background mesh gradient
  static const RadialGradient backgroundGlow = RadialGradient(
    center: Alignment(-0.5, -0.6),
    radius: 1.2,
    colors: [
      Color(0x229B5DE5), // 13% Purple glow
      Color(0x1100F5D4), // 7% Cyan glow
      AppColors.darkBackground,
    ],
    stops: [0.0, 0.5, 1.0],
  );
}
