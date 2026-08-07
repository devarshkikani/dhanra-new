import 'package:dhanra_new/core/common_widgets/glass_card.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/core/theme/app_gradients.dart';
import 'package:dhanra_new/features/budgets/domain/entities/budget_entity.dart';
import 'package:dhanra_new/features/budgets/domain/entities/monthly_budget_summary_entity.dart';
import 'package:flutter/material.dart';

class BudgetSummaryHeroCard extends StatelessWidget {
  const BudgetSummaryHeroCard({
    required this.summary,
    super.key,
    this.onEditTotalLimit,
  });

  final MonthlyBudgetSummaryEntity summary;
  final VoidCallback? onEditTotalLimit;

  Color _getStatusColor(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.safe:
        return AppColors.credit;
      case BudgetStatus.warning:
        return AppColors.warning;
      case BudgetStatus.exceeded:
        return AppColors.debit;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(summary.overallStatus);
    final pctSpent =
        (summary.overallPercentageSpent * 100).clamp(0, 100).toStringAsFixed(1);
    final remainingDays =
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day -
            DateTime.now().day +
            1;

    return GlassCard(
      padding: const EdgeInsets.all(22),
      borderRadius: 24,
      // gradient: AppGradients.cardGlow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Title & Edit Action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Budget Overview',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'August Spending Cap',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: onEditTotalLimit,
                icon: const Icon(Icons.edit_outlined,
                    color: AppColors.secondary, size: 20),
                tooltip: 'Edit Total Budget',
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Total Spent vs Total Limit
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '₹${summary.totalSpent.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              Text(
                ' / ₹${summary.totalLimit.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Visual Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: summary.overallPercentageSpent.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: AppColors.inputBackground,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
          const SizedBox(height: 14),

          // Details Row: Remaining & Daily Safe Spend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Remaining Budget',
                    style:
                        TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '₹${summary.remainingBudget.toStringAsFixed(0)} ($pctSpent% spent)',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Daily Safe Spend ($remainingDays days left)',
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.secondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${summary.dailySafeSpend.toStringAsFixed(0)} / day',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
