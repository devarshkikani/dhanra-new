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
      start = DateTime(start.year, start.month, start.day);
      end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    } else if (timeRange == AnalyticsTimeRange.monthly) {
      start = DateTime(now.year, now.month, 1);
      end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    } else if (timeRange == AnalyticsTimeRange.yearly) {
      start = DateTime(now.year, 1, 1);
      end = DateTime(now.year, 12, 31, 23, 59, 59);
    }

    final filteredTx = transactions.where((t) {
      return t.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
          t.date.isBefore(end.add(const Duration(seconds: 1)));
    }).toList();

    double totalIncome = 0;
    double totalExpense = 0;

    final Map<String, CategorySpendingEntity> catMap = {};
    final Map<String, double> dailySpendMap = {};

    for (final tx in filteredTx) {
      if (tx.type == TransactionType.income) {
        totalIncome += tx.amount;
      } else if (tx.type == TransactionType.expense) {
        totalExpense += tx.amount;

        // Track category totals
        final existing = catMap[tx.categoryId];
        final newAmt = (existing?.amount ?? 0) + tx.amount;

        catMap[tx.categoryId] = CategorySpendingEntity(
          categoryId: tx.categoryId,
          categoryName: tx.categoryName,
          categoryIcon: tx.categoryIcon,
          categoryColor: tx.categoryColor,
          amount: newAmt,
          percentage: 0,
        );

        // Track daily spend totals
        final dayKey =
            '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}-${tx.date.day.toString().padLeft(2, '0')}';
        dailySpendMap[dayKey] = (dailySpendMap[dayKey] ?? 0) + tx.amount;
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
    final savingsRate = totalIncome > 0
        ? ((totalIncome - totalExpense) / totalIncome * 100).clamp(0.0, 100.0)
        : 0.0;

    // Determine Peak Spending Day
    String peakSpendDay = 'N/A';
    double peakSpendAmount = 0.0;
    if (dailySpendMap.isNotEmpty) {
      final sortedDaily = dailySpendMap.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final topEntry = sortedDaily.first;
      peakSpendAmount = topEntry.value;

      final parsed = DateTime.parse(topEntry.key);
      const weekdayNames = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun'
      ];
      const monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      peakSpendDay =
          '${weekdayNames[parsed.weekday - 1]}, ${monthNames[parsed.month - 1]} ${parsed.day}';
    }

    // Build trend chart points based on selected timeRange
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
    } else if (timeRange == AnalyticsTimeRange.yearly) {
      const monthLabels = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      for (int m = 1; m <= 12; m++) {
        double mInc = 0;
        double mExp = 0;

        for (final t in filteredTx) {
          if (t.date.year == start.year && t.date.month == m) {
            if (t.type == TransactionType.income) mInc += t.amount;
            if (t.type == TransactionType.expense) mExp += t.amount;
          }
        }

        trends.add(MonthlyTrendEntity(
          label: monthLabels[m - 1],
          income: mInc,
          expense: mExp,
          cashFlow: mInc - mExp,
        ));
      }
    } else {
      // Monthly or Custom: 4-week breakdown
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
      savingsRate: savingsRate,
      peakSpendDay: peakSpendDay,
      peakSpendAmount: peakSpendAmount,
      timeRange: timeRange,
      startDate: start,
      endDate: end,
    );
  }
}
