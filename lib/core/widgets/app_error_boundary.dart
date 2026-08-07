import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/theme/app_typography.dart';
import 'package:dhanra_new/core/widgets/app_button.dart';
import 'package:dhanra_new/core/widgets/app_card.dart';
import 'package:flutter/material.dart';

class AppErrorBoundary extends StatefulWidget {
  final Widget child;

  const AppErrorBoundary({
    super.key,
    required this.child,
  });

  static void initializeGlobalErrorHandler() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };
  }

  @override
  State<AppErrorBoundary> createState() => _AppErrorBoundaryState();
}

class _AppErrorBoundaryState extends State<AppErrorBoundary> {
  bool _hasError = false;
  Object? _errorDetails;

  @override
  void initState() {
    super.initState();
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return _buildErrorCard(details.exceptionAsString());
    };
  }

  Widget _buildErrorCard(String errorMsg) {
    return Material(
      color: AppColors.darkBackground,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: AppSpacing.paddingMD,
            child: AppCard(
              variant: AppCardVariant.standard,
              backgroundColor: AppColors.darkCard,
              padding: AppSpacing.paddingLG,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.error,
                      size: 40,
                    ),
                  ),
                  AppSpacing.vGapMD,
                  Text(
                    'Something Went Wrong',
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.vGapXS,
                  Text(
                    'An unexpected rendering issue occurred. Your financial data is safe.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppSpacing.vGapLG,
                  AppButton(
                    title: 'Reload Component',
                    icon: Icons.refresh_rounded,
                    onPressed: () {
                      setState(() {
                        _hasError = false;
                        _errorDetails = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorCard(_errorDetails?.toString() ?? 'Unknown error');
    }

    return widget.child;
  }
}
