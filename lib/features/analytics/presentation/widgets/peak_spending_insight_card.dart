import 'package:dhanra_new/core/common_widgets/glass_card.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_spacing.dart';
import 'package:dhanra_new/core/theme/app_typography.dart';
import 'package:dhanra_new/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:flutter/material.dart';

class PeakSpendingInsightCard extends StatelessWidget {
  const PeakSpendingInsightCard({required this.data, super.key});

  final AnalyticsDataEntity data;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: AppSpacing.paddingMD,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
              AppSpacing.hGapSM,
              Text(
                'Spending Highlights & Peak Insights',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          AppSpacing.vGapMD,
          Row(
            children: [
              // 1. Top Category Highlight
              Expanded(
                child: Container(
                  padding: AppSpacing.paddingSM,
                  decoration: BoxDecoration(
                    color: AppColors.card.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.category_rounded,
                            size: 16,
                            color: AppColors.accent,
                          ),
                          AppSpacing.hGapXXS,
                          Expanded(
                            child: Text(
                              'TOP CATEGORY',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.vGapXS,
                      Text(
                        data.topExpenseCategory,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.vGapXXS,
                      Text(
                        data.categoryBreakdowns.isNotEmpty
                            ? '₹${data.categoryBreakdowns.first.amount.toStringAsFixed(0)} (${data.categoryBreakdowns.first.percentage.toStringAsFixed(1)}%)'
                            : '₹0',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.hGapSM,

              // 2. Busiest Day Highlight
              Expanded(
                child: Container(
                  padding: AppSpacing.paddingSM,
                  decoration: BoxDecoration(
                    color: AppColors.card.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.event_repeat_rounded,
                            size: 16,
                            color: AppColors.debit,
                          ),
                          AppSpacing.hGapXXS,
                          Expanded(
                            child: Text(
                              'PEAK SPEND DAY',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.vGapXS,
                      Text(
                        data.peakSpendDay,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.titleSmall.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.vGapXXS,
                      Text(
                        '₹${data.peakSpendAmount.toStringAsFixed(0)} spent',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.debit,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
