import 'package:flutter/material.dart';

/// Single source of truth for 8dp spatial tokens in Dhanra.
abstract class AppSpacing {
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // EdgeInsets Helper Presets
  static const EdgeInsets paddingXXS = EdgeInsets.all(xxs);
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);
  static const EdgeInsets paddingSM = EdgeInsets.all(sm);
  static const EdgeInsets paddingMD = EdgeInsets.all(md);
  static const EdgeInsets paddingLG = EdgeInsets.all(lg);
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);

  static const EdgeInsets paddingHorizontalSM = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMD = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLG = EdgeInsets.symmetric(horizontal: lg);

  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets paddingVerticalSM = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMD = EdgeInsets.symmetric(vertical: md);

  // Vertical Spacers
  static const Widget vGapXXS = SizedBox(height: xxs);
  static const Widget vGapXS = SizedBox(height: xs);
  static const Widget vGapSM = SizedBox(height: sm);
  static const Widget vGapMD = SizedBox(height: md);
  static const Widget vGapLG = SizedBox(height: lg);
  static const Widget vGapXL = SizedBox(height: xl);

  // Horizontal Spacers
  static const Widget hGapXXS = SizedBox(width: xxs);
  static const Widget hGapXS = SizedBox(width: xs);
  static const Widget hGapSM = SizedBox(width: sm);
  static const Widget hGapMD = SizedBox(width: md);
  static const Widget hGapLG = SizedBox(width: lg);
  static const Widget hGapXL = SizedBox(width: xl);
}
