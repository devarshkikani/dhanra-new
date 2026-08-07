import 'package:flutter/material.dart';

/// Single source of truth for border radius tokens in Dhanra.
abstract class AppRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double pill = 999.0;

  static const Radius radiusXS = Radius.circular(xs);
  static const Radius radiusSM = Radius.circular(sm);
  static const Radius radiusMD = Radius.circular(md);
  static const Radius radiusLG = Radius.circular(lg);
  static const Radius radiusXL = Radius.circular(xl);
  static const Radius radiusPill = Radius.circular(pill);

  static const BorderRadius borderXS = BorderRadius.all(radiusXS);
  static const BorderRadius borderSM = BorderRadius.all(radiusSM);
  static const BorderRadius borderMD = BorderRadius.all(radiusMD);
  static const BorderRadius borderLG = BorderRadius.all(radiusLG);
  static const BorderRadius borderXL = BorderRadius.all(radiusXL);
  static const BorderRadius borderPill = BorderRadius.all(radiusPill);
}
