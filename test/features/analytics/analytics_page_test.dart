import 'package:dhanra_new/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:dhanra_new/features/analytics/domain/entities/category_spending_entity.dart';
import 'package:dhanra_new/features/analytics/domain/entities/monthly_trend_entity.dart';
import 'package:dhanra_new/features/analytics/presentation/widgets/analytics_metrics_grid.dart';
import 'package:dhanra_new/features/analytics/presentation/widgets/peak_spending_insight_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const sampleAnalyticsData = AnalyticsDataEntity(
    totalIncome: 150000,
    totalExpense: 45000,
    netCashFlow: 105000,
    averageDailySpend: 1500,
    topExpenseCategory: 'Housing & Rent',
    categoryBreakdowns: [
      CategorySpendingEntity(
        categoryId: 'cat_rent',
        categoryName: 'Housing & Rent',
        categoryIcon: 'home',
        categoryColor: '#FF5252',
        amount: 30000,
        percentage: 66.7,
      ),
      CategorySpendingEntity(
        categoryId: 'cat_food',
        categoryName: 'Food & Dining',
        categoryIcon: 'restaurant',
        categoryColor: '#FF9800',
        amount: 15000,
        percentage: 33.3,
      ),
    ],
    trends: [
      MonthlyTrendEntity(
        label: 'W1',
        income: 150000,
        expense: 45000,
        cashFlow: 105000,
      ),
    ],
    savingsRate: 70.0,
    peakSpendDay: 'Sun, Aug 10',
    peakSpendAmount: 30000,
  );

  group('Analytics Widgets Tests', () {
    testWidgets('AnalyticsMetricsGrid renders total income, expense, and savings rate',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnalyticsMetricsGrid(data: sampleAnalyticsData),
          ),
        ),
      );

      expect(find.text('Total Income'), findsOneWidget);
      expect(find.text('Total Expense'), findsOneWidget);
      expect(find.text('Net Savings Rate'), findsOneWidget);
      expect(find.text('70.0%'), findsOneWidget);
      expect(find.text('Healthy'), findsOneWidget);
    });

    testWidgets('PeakSpendingInsightCard renders top category and peak spend day',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PeakSpendingInsightCard(data: sampleAnalyticsData),
          ),
        ),
      );

      expect(find.text('Spending Highlights & Peak Insights'), findsOneWidget);
      expect(find.text('TOP CATEGORY'), findsOneWidget);
      expect(find.text('Housing & Rent'), findsOneWidget);
      expect(find.text('PEAK SPEND DAY'), findsOneWidget);
      expect(find.text('Sun, Aug 10'), findsOneWidget);
    });
  });
}
