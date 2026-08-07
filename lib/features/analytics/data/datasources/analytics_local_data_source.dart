import 'package:dhanra_new/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:dhanra_new/features/analytics/domain/entities/category_spending_entity.dart';
import 'package:dhanra_new/features/analytics/domain/entities/monthly_trend_entity.dart';
import 'package:dhanra_new/features/transactions/domain/entities/transaction_entity.dart';
import 'package:injectable/injectable.dart';

abstract class AnalyticsLocalDataSource {
  AnalyticsDataEntity calculateAnalytics({
    required List<TransactionEntity> transactions,
    AnalyticsTimeRange timeRange = AnalyticsTimeRange.monthly,
    DateTime? startDate,
    DateTime? endDate,
  });
}

@LazySingleton(as: AnalyticsLocalDataSource)
class AnalyticsLocalDataSourceImpl implements AnalyticsLocalDataSource {
  @override
  AnalyticsDataEntity calculateAnalytics({
    required List<TransactionEntity> transactions,
    AnalyticsTimeRange timeRange = AnalyticsTimeRange.monthly,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final now = DateTime.now();

    DateTime start = startDate ?? DateTime(now.year, now.month, 1);
    DateTime end = endDate ?? now;

    if (timeRange == AnalyticsTimeRange.weekly) {
      start = now.subtract(Duration(days: now.weekday - 1));
      end = now;
    } else if (timeRange == AnalyticsTimeRange.monthly) {
      start = DateTime(now.year, now.month, 1);
      end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    }

    final filteredTx = transactions.where((t) {
      return t.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
          t.date.isBefore(end.add(const Duration(seconds: 1)));
    }).toList();

    double totalIncome = 0;
    double totalExpense = 0;

    final Map<String, CategorySpendingEntity> catMap = {};

    for (final tx in filteredTx) {
      if (tx.type == TransactionType.income) {
        totalIncome += tx.amount;
      } else if (tx.type == TransactionType.expense) {
        totalExpense += tx.amount;

        final existing = catMap[tx.categoryId];
        final newAmt = (existing?.amount ?? 0) + tx.amount;

        catMap[tx.categoryId] = CategorySpendingEntity(
          categoryId: tx.categoryId,
          categoryName: tx.categoryName,
          categoryIcon: tx.categoryIcon,
          categoryColor: tx.categoryColor,
          amount: newAmt,
          percentage: 0, // Will calculate below
        );
      }
    }

    // Calculate category breakdown percentages
    final categoryList = catMap.values.map((c) {
      final pct = totalExpense > 0 ? (c.amount / totalExpense) * 100 : 0.0;
      return CategorySpendingEntity(
        categoryId: c.categoryId,
        categoryName: c.categoryName,
        categoryIcon: c.categoryIcon,
        categoryColor: c.categoryColor,
        amount: c.amount,
        percentage: pct,
      );
    }).toList();

    categoryList.sort((a, b) => b.amount.compareTo(a.amount));

    final topCategory =
        categoryList.isNotEmpty ? categoryList.first.categoryName : 'None';

    final daysInPeriod = end.difference(start).inDays + 1;
    final avgDailySpend = daysInPeriod > 0 ? totalExpense / daysInPeriod : 0.0;
    final netCashFlow = totalIncome - totalExpense;

    // Build trend chart points
    final List<MonthlyTrendEntity> trends = [];
    if (timeRange == AnalyticsTimeRange.weekly) {
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      for (int i = 0; i < 7; i++) {
        final dayDate = start.add(Duration(days: i));
        double dayInc = 0;
        double dayExp = 0;

        for (final t in filteredTx) {
          if (t.date.year == dayDate.year &&
              t.date.month == dayDate.month &&
              t.date.day == dayDate.day) {
            if (t.type == TransactionType.income) dayInc += t.amount;
            if (t.type == TransactionType.expense) dayExp += t.amount;
          }
        }

        trends.add(MonthlyTrendEntity(
          label: weekdays[i],
          income: dayInc,
          expense: dayExp,
          cashFlow: dayInc - dayExp,
        ));
      }
    } else {
      // Monthly 4-week breakdown
      for (int week = 1; week <= 4; week++) {
        final weekStart = start.add(Duration(days: (week - 1) * 7));
        final weekEnd = start.add(Duration(days: week * 7));

        double wInc = 0;
        double wExp = 0;

        for (final t in filteredTx) {
          if (t.date.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
              t.date.isBefore(weekEnd)) {
            if (t.type == TransactionType.income) wInc += t.amount;
            if (t.type == TransactionType.expense) wExp += t.amount;
          }
        }

        trends.add(MonthlyTrendEntity(
          label: 'W$week',
          income: wInc,
          expense: wExp,
          cashFlow: wInc - wExp,
        ));
      }
    }

    return AnalyticsDataEntity(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netCashFlow: netCashFlow,
      averageDailySpend: avgDailySpend,
      topExpenseCategory: topCategory,
      categoryBreakdowns: categoryList,
      trends: trends,
      timeRange: timeRange,
      startDate: start,
      endDate: end,
    );
  }
}
