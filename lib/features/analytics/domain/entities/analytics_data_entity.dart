import 'package:dhanra_new/features/analytics/domain/entities/category_spending_entity.dart';
import 'package:dhanra_new/features/analytics/domain/entities/monthly_trend_entity.dart';
import 'package:equatable/equatable.dart';

enum AnalyticsTimeRange {
  weekly,
  monthly,
  yearly,
  custom,
}

extension AnalyticsTimeRangeX on AnalyticsTimeRange {
  String get displayName {
    switch (this) {
      case AnalyticsTimeRange.weekly:
        return 'This Week';
      case AnalyticsTimeRange.monthly:
        return 'This Month';
      case AnalyticsTimeRange.yearly:
        return 'This Year';
      case AnalyticsTimeRange.custom:
        return 'Custom';
    }
  }
}

class AnalyticsDataEntity extends Equatable {
  const AnalyticsDataEntity({
    required this.totalIncome,
    required this.totalExpense,
    required this.netCashFlow,
    required this.averageDailySpend,
    required this.topExpenseCategory,
    required this.categoryBreakdowns,
    required this.trends,
    this.savingsRate = 0.0,
    this.peakSpendDay = 'N/A',
    this.peakSpendAmount = 0.0,
    this.timeRange = AnalyticsTimeRange.monthly,
    this.startDate,
    this.endDate,
  });

  final double totalIncome;
  final double totalExpense;
  final double netCashFlow;
  final double averageDailySpend;
  final String topExpenseCategory;
  final List<CategorySpendingEntity> categoryBreakdowns;
  final List<MonthlyTrendEntity> trends;
  final double savingsRate;
  final String peakSpendDay;
  final double peakSpendAmount;
  final AnalyticsTimeRange timeRange;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [
        totalIncome,
        totalExpense,
        netCashFlow,
        averageDailySpend,
        topExpenseCategory,
        categoryBreakdowns,
        trends,
        savingsRate,
        peakSpendDay,
        peakSpendAmount,
        timeRange,
        startDate,
        endDate,
      ];
}
