import 'dart:ui';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/theme/app_typography.dart';
import 'package:dhanra_new/core/theme/currency_extension.dart';
import 'package:flutter/material.dart';

/// Glassmorphic HeroBalanceCard matching original _buildNetAmountCard design
/// with monthly Income, Spends, watermark, and floating Total Balance bar with +Add Txn action.
class HeroBalanceCard extends StatelessWidget {
  const HeroBalanceCard({
    required this.userName,
    required this.totalBalance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    this.savingsRate = 0.0,
    this.onAddTransaction,
    super.key,
  });

  final String userName;
  final double totalBalance;
  final double monthlyIncome;
  final double monthlyExpense;
  final double savingsRate;
  final VoidCallback? onAddTransaction;

  static const _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
    final isPositive = totalBalance >= 0;
    final currentMonth = _monthNames[DateTime.now().month - 1];

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // 1. Upper Net Amount & Income/Spends Main Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 42,
          ),
          decoration: BoxDecoration(
            color: AppColors.darkCard.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Rupee Watermark
              Positioned(
                right: -10,
                top: -10,
                child: Opacity(
                  opacity: 0.06,
                  child: Image.asset(
                    'assets/images/ruppe.png',
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.currency_rupee_rounded,
                      size: 90,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Brand Header & Current Month
                  Row(
                    children: [
                      const Icon(
                        Icons.bar_chart_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      AppSpacing.hGapXXS,
                      Text(
                        'Dhanra',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppSpacing.hGapXXS,
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      AppSpacing.hGapXXS,
                      Text(
                        currentMonth,
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vGapMD,
                  // Income & Spends Row Side-by-Side
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Income Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const RotatedBox(
                                quarterTurns: 1,
                                child: Icon(
                                  Icons.arrow_outward_rounded,
                                  size: 16,
                                  color: AppColors.credit,
                                ),
                              ),
                              AppSpacing.hGapXXS,
                              Text(
                                'Income',
                                style: AppTypography.labelMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${context.currencySymbol}${monthlyIncome.toStringAsFixed(2)}',
                            style: AppTypography.titleLarge.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.credit,
                            ),
                          ),
                        ],
                      ),
                      // Spends Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.arrow_outward_rounded,
                                size: 16,
                                color: AppColors.debit,
                              ),
                              AppSpacing.hGapXXS,
                              Text(
                                'Spends',
                                style: AppTypography.labelMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.vGapXXS,
                          Text(
                            '${context.currencySymbol}${monthlyExpense.toStringAsFixed(2)}',
                            style: AppTypography.titleLarge.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.debit,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // 2. Overlapping Floating Total Balance Glass Bar
        Positioned(
          bottom: -40,
          left: 14,
          right: 14,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface.withValues(alpha: 0.90),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Total Balance',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            AppSpacing.hGapXXS,
                            Icon(
                              isPositive
                                  ? Icons.trending_up_rounded
                                  : Icons.trending_down_rounded,
                              size: 16,
                              color: isPositive
                                  ? AppColors.credit
                                  : AppColors.debit,
                            ),
                          ],
                        ),
                        AppSpacing.vGapXXS,
                        Text(
                          '${context.currencySymbol}${totalBalance.toStringAsFixed(2)}',
                          style: AppTypography.titleLarge.copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    // Highlighted Add Transaction Button
                    Material(
                      color: Colors.transparent,
                      child: GestureDetector(
                        onTap: onAddTransaction,
                        // borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primaryDark,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primary.withValues(alpha: 0.45),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
