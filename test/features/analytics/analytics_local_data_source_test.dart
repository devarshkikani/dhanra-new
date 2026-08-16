import 'package:dhanra_new/features/analytics/data/datasources/analytics_local_data_source.dart';
import 'package:dhanra_new/features/analytics/domain/entities/analytics_data_entity.dart';
import 'package:dhanra_new/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AnalyticsLocalDataSourceImpl dataSource;

  final now = DateTime.now();
  final sampleTransactions = [
    TransactionEntity(
      id: 'tx_1',
      title: 'Monthly Salary',
      amount: 100000,
      type: TransactionType.income,
      date: DateTime(now.year, now.month, 2),
      accountId: 'acc_1',
      accountName: 'Bank',
      categoryId: 'cat_income',
      categoryName: 'Salary',
      categoryIcon: 'work',
      categoryColor: '#00C853',
    ),
    TransactionEntity(
      id: 'tx_2',
      title: 'Rent Payment',
      amount: 25000,
      type: TransactionType.expense,
      date: DateTime(now.year, now.month, 5),
      accountId: 'acc_1',
      accountName: 'Bank',
      categoryId: 'cat_rent',
      categoryName: 'Housing & Rent',
      categoryIcon: 'home',
      categoryColor: '#FF5252',
    ),
    TransactionEntity(
      id: 'tx_3',
      title: 'Grocery Shopping',
      amount: 5000,
      type: TransactionType.expense,
      date: DateTime(now.year, now.month, 5),
      accountId: 'acc_1',
      accountName: 'Bank',
      categoryId: 'cat_food',
      categoryName: 'Food & Dining',
      categoryIcon: 'restaurant',
      categoryColor: '#FF9800',
    ),
  ];

  setUp(() {
    dataSource = AnalyticsLocalDataSourceImpl();
  });

  group('AnalyticsLocalDataSource Unit Tests', () {
    test('calculates monthly analytics correctly', () {
      final data = dataSource.calculateAnalytics(
        transactions: sampleTransactions,
        timeRange: AnalyticsTimeRange.monthly,
      );

      expect(data.totalIncome, equals(100000));
      expect(data.totalExpense, equals(30000));
      expect(data.netCashFlow, equals(70000));
      expect(data.savingsRate, equals(70.0));
      expect(data.topExpenseCategory, equals('Housing & Rent'));
      expect(data.peakSpendAmount, equals(30000));
    });

    test('calculates yearly analytics with 12 monthly trend data points', () {
      final data = dataSource.calculateAnalytics(
        transactions: sampleTransactions,
        timeRange: AnalyticsTimeRange.yearly,
      );

      expect(data.timeRange, equals(AnalyticsTimeRange.yearly));
      expect(data.trends.length, equals(12));
    });

    test('calculates weekly analytics with 7 day trend data points', () {
      final data = dataSource.calculateAnalytics(
        transactions: sampleTransactions,
        timeRange: AnalyticsTimeRange.weekly,
      );

      expect(data.timeRange, equals(AnalyticsTimeRange.weekly));
      expect(data.trends.length, equals(7));
    });
  });
}
