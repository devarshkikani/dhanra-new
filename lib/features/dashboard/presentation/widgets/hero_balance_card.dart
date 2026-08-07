import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_radius.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class HeroBalanceCard extends StatelessWidget {
  const HeroBalanceCard({
    required this.userName,
    required this.totalBalance,
    required this.savingsRate,
    super.key,
  });

  final String userName;
  final double totalBalance;
  final double savingsRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: AppRadius.borderXL,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL BALANCE',
                    style: AppTypography.labelSmall.copyWith(
                      letterSpacing: 1.2,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSpacing.vGapXXS,
                  Text(
                    'Hello, $userName 👋',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.12),
                  borderRadius: AppRadius.borderMD,
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      color: AppColors.secondary,
                      size: 16,
                    ),
                    AppSpacing.hGapXXS,
                    Text(
                      '${savingsRate.toStringAsFixed(1)}% Saved',
                      style: AppTypography.labelMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.vGapMD,
          Text(
            '₹${totalBalance.toStringAsFixed(2)}',
            style: AppTypography.displayLarge.copyWith(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
