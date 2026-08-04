import 'dart:async';
import 'package:dhanra_new/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:injectable/injectable.dart';

abstract class DashboardLocalDataSource {
  Future<DashboardSummaryModel> getSummary();
  Stream<DashboardSummaryModel> watchSummary();
  Future<void> updateSummary(DashboardSummaryModel summary);
}

@LazySingleton(as: DashboardLocalDataSource)
class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  DashboardLocalDataSourceImpl() {
    _initSeedData();
  }

  late DashboardSummaryModel _currentSummary;
  final StreamController<DashboardSummaryModel> _controller =
      StreamController<DashboardSummaryModel>.broadcast();

  void _initSeedData() {
    _currentSummary = const DashboardSummaryModel(
      userName: 'Don Daniel',
      totalBalance: 84550,
      monthlyIncome: 125000,
      monthlyExpense: 40450,
      savingsAmount: 84550,
      savingsRatePercentage: 67.6,
      budgetSpentAmount: 40450,
      budgetTotalLimit: 60000,
      aiInsightSummary:
          'Great job! You saved 67.6% of your income this month. You are ₹19,550 below your monthly budget cap.',
      recentTransactions: [
        DashboardRecentTransactionModel(
          id: 'tx_1',
          title: 'Salary Deposit',
          category: 'Income',
          amount: 125000,
          date: '01 Aug',
          isCredit: true,
        ),
        DashboardRecentTransactionModel(
          id: 'tx_2',
          title: 'Apple Store Purchase',
          category: 'Electronics',
          amount: 24900,
          date: '02 Aug',
          isCredit: false,
        ),
        DashboardRecentTransactionModel(
          id: 'tx_3',
          title: 'Starbucks Coffee',
          category: 'Food & Dining',
          amount: 450,
          date: '03 Aug',
          isCredit: false,
        ),
        DashboardRecentTransactionModel(
          id: 'tx_4',
          title: 'Grocery Supermarket',
          category: 'Groceries',
          amount: 3200,
          date: '03 Aug',
          isCredit: false,
        ),
        DashboardRecentTransactionModel(
          id: 'tx_5',
          title: 'Freelance Design Payment',
          category: 'Income',
          amount: 15000,
          date: '04 Aug',
          isCredit: true,
        ),
      ],
    );
  }

  @override
  Future<DashboardSummaryModel> getSummary() async {
    // Simulating quick async read
    return _currentSummary;
  }

  @override
  Stream<DashboardSummaryModel> watchSummary() async* {
    yield _currentSummary;
    yield* _controller.stream;
  }

  @override
  Future<void> updateSummary(DashboardSummaryModel summary) async {
    _currentSummary = summary;
    _controller.add(_currentSummary);
  }
}
