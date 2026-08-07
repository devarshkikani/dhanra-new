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
    _initData();
  }

  late DashboardSummaryModel _currentSummary;
  final StreamController<DashboardSummaryModel> _controller =
      StreamController<DashboardSummaryModel>.broadcast();

  void _initData() {
    _currentSummary = const DashboardSummaryModel(
      userName: 'User',
      totalBalance: 0,
      monthlyIncome: 0,
      monthlyExpense: 0,
      savingsAmount: 0,
      savingsRatePercentage: 0,
      budgetSpentAmount: 0,
      budgetTotalLimit: 0,
      aiInsightSummary:
          'Welcome to Dhanra! Add your bank accounts and log transactions to track your finances in real time.',
      recentTransactions: [],
    );
  }

  @override
  Future<DashboardSummaryModel> getSummary() async {
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
