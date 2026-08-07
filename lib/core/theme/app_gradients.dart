import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Clean, restrained gradient standards for Dhanra UI.
/// Gradients are reserved ONLY for primary CTA buttons and subtle hero card borders.
abstract class AppGradients {
  /// Clean, professional primary CTA button gradient
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle dark card surface gradient
  static const LinearGradient cardSurface = LinearGradient(
    colors: [
      Color(0xFF1B1B20),
      Color(0xFF141417),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle hero balance card gradient (Refined dark matte)
  static const LinearGradient heroCard = LinearGradient(
    colors: [
      Color(0xFF1E1C28),
      Color(0xFF141418),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
