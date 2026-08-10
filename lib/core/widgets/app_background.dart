import 'dart:ui';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// AppBackground provides the signature ambient radial gradient blur and
/// circle pattern UI overlay extending seamlessly behind the status bar & AppBar
/// through the entire app body.
class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.showCircles = true,
    this.primaryColor,
  });

  final Widget child;
  final bool showCircles;
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorTheme = primaryColor ?? AppColors.primary;

    return Stack(
      alignment: Alignment.topLeft,
      children: [
        // Base dark background color
        // Positioned.fill(
        //   child: Container(
        //     color: AppColors.darkBackground,
        //   ),
        // ),
        // Ambient radial glow positioned at top behind AppBar & Status Bar
        // ImageFiltered(
        //   imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       shape: BoxShape.circle,
        //       gradient: RadialGradient(
        //         colors: [
        //           colorTheme.withValues(alpha: 0.45),
        //           colorTheme.withValues(alpha: 0.12),
        //           Colors.transparent,
        //         ],
        //         stops: const [0.0, 0.5, 1.0],
        //       ),
        //     ),
        //   ),
        // ),
        Positioned.fill(
          top: -size.height,
          left: -size.width,
          // right: right,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    colorTheme.withValues(alpha: 0.45),
                    colorTheme.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
        ),
        // Geometric circle UI background pattern
        if (showCircles)
          Image.asset(
            'assets/images/circle_ui.png',
            opacity: const AlwaysStoppedAnimation(0.7),
            fit: BoxFit.cover,
          ),
        // Main screen content (Scaffold with transparent AppBar)
        Positioned.fill(
          child: child,
        ),
      ],
    );
  }
}
