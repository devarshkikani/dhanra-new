import 'package:dhanra_new/core/common_widgets/glass_card.dart';
import 'package:dhanra_new/core/theme/app_colors.dart';
import 'package:dhanra_new/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:flutter/material.dart';

class AnalyticsMetricsGrid extends StatelessWidget {
  const AnalyticsMetricsGrid({
    required this.data,
    super.key,
  });

  final AnalyticsDataEntity data;

  Color _getSavingsRateColor(double rate) {
    if (rate >= 20) return AppColors.credit;
    if (rate >= 10) return AppColors.warning;
    return AppColors.debit;
  }

  @override
  Widget build(BuildContext context) {
    final savingsColor = _getSavingsRateColor(data.savingsRate);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                title: 'Total Income',
                amount: '₹${data.totalIncome.toStringAsFixed(0)}',
                color: AppColors.credit,
                icon: Icons.south_west_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricTile(
                title: 'Total Expense',
                amount: '₹${data.totalExpense.toStringAsFixed(0)}',
                color: AppColors.debit,
                icon: Icons.north_east_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                title: 'Net Savings Rate',
                amount: '${data.savingsRate.toStringAsFixed(1)}%',
                color: savingsColor,
                icon: Icons.savings_rounded,
                badgeText: data.savingsRate >= 20
                    ? 'Healthy'
                    : (data.savingsRate >= 10 ? 'Moderate' : 'Low'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricTile(
                title: 'Daily Avg Spend',
                amount: '₹${data.averageDailySpend.toStringAsFixed(0)}/day',
                color: AppColors.primary,
                icon: Icons.speed_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String amount,
    required Color color,
    required IconData icon,
    String? badgeText,
  }) {
    return GlassCard(
      borderRadius: 18,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  amount,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (badgeText != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
