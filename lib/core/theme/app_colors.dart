import 'package:flutter/material.dart';

/// Single source of truth for color tokens in Dhanra.
/// Standardized for a clean, sleek, professional fintech UI.
abstract class AppColors {
  // Base Backgrounds (Solid Matte Dark Theme)
  static const Color background = Color(0xFF0A0A0C);
  static const Color darkBackground = Color(0xFF0A0A0C);
  static const Color surface = Color(0xFF141417);
  static const Color darkSurface = Color(0xFF141417);
  static const Color card = Color(0xFF18181C);
  static const Color darkCard = Color(0xFF18181C);
  static const Color elevatedSurface = Color(0xFF202026);

  // Light Mode Palette
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF1F5F9);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Brand Primary (Clean Violet Accent)
  static const Color primary = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF6D28D9);
  static const Color primaryLight = Color(0xFFA78BFA);

  // Brand Secondary (Teal Cyan Accent)
  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryDark = Color(0xFF059669);
  static const Color secondaryLight = Color(0xFF34D399);

  // Brand Accent (Amber/Orange)
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentDark = Color(0xD97706);
  static const Color accentLight = Color(0xFBBF24);

  // Text Colors
  static const Color textPrimary = Color(0xFFF3F4F6);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textHint = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF4B5563);
  static const Color darkTextPrimary = textPrimary;
  static const Color darkTextSecondary = textSecondary;

  // Status & Semantic Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  static const Color credit = Color(0xFF10B981);
  static const Color debit = Color(0xFFEF4444);
  static const Color neutral = Color(0xFF9CA3AF);

  // Interactive & Input Tokens
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = Color(0xFF202026);
  static const Color buttonDisabled = Color(0xFF27272A);

  static const Color inputBackground = Color(0xFF141417);
  static const Color inputBorder = Color(0xFF27272A);
  static const Color inputFocusedBorder = primary;

  // Glassmorphism & Shadow Overlays
  static const Color shadow = Color(0x40000000);
  static Color glassBorder = Colors.white.withValues(alpha: 0.08);
  static Color glassBackground = Colors.white.withValues(alpha: 0.04);
  static Color glassHighlight = Colors.white.withValues(alpha: 0.10);
}
