import 'package:flutter/material.dart';

/// Dhanra curated color palette aligning with Dhanra design standards.
abstract class AppColors {
  // Base Backgrounds (Deep OLED Dark Theme)
  static const Color darkBackground = Color(0xFF0A0A0A); // Deep Obsidian Black
  static const Color darkSurface = Color(0xFF121212); // Elevated dark container
  static const Color darkCard = Color(0xFF1C1C1E); // Card background

  // Light Mode Palette
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF1F5F9);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Brand Primary (Poli Purple System)
  static const Color primary = Color(0xFF9B5DE5);
  static const Color primaryDark = Color(0xFF6F3CC9);
  static const Color primaryLight = Color(0xFFCBA2F3);

  // Brand Secondary (Park Mint / Cyan System)
  static const Color secondary = Color(0xFF00F5D4);
  static const Color secondaryDark = Color(0xFF00C9A7);
  static const Color secondaryLight = Color(0xFF8BF9E6);

  // Brand Accent (Orange Sunshine System)
  static const Color accent = Color(0xFFFFA500);
  static const Color accentDark = Color(0xFFCC8400);
  static const Color accentLight = Color(0xFFFFC266);

  // Text Colors
  static const Color textPrimary = Color(0xFFEFEFEF); // Soft white
  static const Color textSecondary = Color(0xFFAAAAAA); // Light gray
  static const Color textMuted = Color(0xFF666666); // Muted hint text
  static const Color darkTextPrimary = textPrimary;
  static const Color darkTextSecondary = textSecondary;

  // Status & Transaction Semantics
  static const Color success = Color(0xFF00C853);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFAB00);
  static const Color info = Color(0xFF448AFF);
  static const Color credit = Color(0xFF00E676);
  static const Color debit = Color(0xFFFF3D00);
  static const Color neutral = Color(0xFFB0BEC5);

  // Input Fields & Interactive States
  static const Color inputBackground = Color(0xFF1E1E1E);
  static const Color inputBorder = Color(0xFF3C3C3C);
  static const Color inputFocusedBorder = primary;

  // Glassmorphism overlays
  static Color glassBorder = Colors.white.withValues(alpha: 0.12);
  static Color glassBackground = Colors.white.withValues(alpha: 0.06);
  static Color glassHighlight = Colors.white.withValues(alpha: 0.15);
}
