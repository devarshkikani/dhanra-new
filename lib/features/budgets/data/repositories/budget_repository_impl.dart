import 'dart:async';
import 'package:dhanra_new/features/budgets/data/datasources/budget_local_data_source.dart';
import 'package:dhanra_new/features/budgets/data/models/budget_model.dart';
import 'package:dhanra_new/features/budgets/domain/entities/budget_entity.dart';
import 'package:dhanra_new/features/budgets/domain/entities/monthly_budget_summary_entity.dart';
import 'package:dhanra_new/features/budgets/domain/repositories/budget_repository.dart';
import 'package:dhanra_new/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:dhanra_new/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:dhanra_new/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:dhanra_new/features/transactions/data/models/transaction_model.dart';
import 'package:dhanra_new/features/transactions/domain/entities/transaction_entity.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BudgetRepository)
class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(
    this._localDataSource,
    this._transactionLocalDataSource,
    this._dashboardLocalDataSource,
  ) {
    _transactionLocalDataSource
        .watchTransactions()
        .listen(_onTransactionsChanged);
  }

  final BudgetLocalDataSource _localDataSource;
  final TransactionLocalDataSource _transactionLocalDataSource;
  final DashboardLocalDataSource _dashboardLocalDataSource;

  Future<void> _onTransactionsChanged(
      List<TransactionModel> transactions) async {
    try {
      final Map<String, double> categorySpentMap = {};
      double totalExpense = 0;

      for (final tx in transactions) {
        if (tx.type == TransactionType.expense) {
          totalExpense += tx.amount;
          categorySpentMap[tx.categoryId] =
              (categorySpentMap[tx.categoryId] ?? 0.0) + tx.amount;
        }
      }

      await _localDataSource.updateCategorySpentAmounts(categorySpentMap);
      await _syncDashboardBudgetCard(totalExpense);
    } catch (_) {}
  }

  Future<void> _syncDashboardBudgetCard(double totalExpense) async {
    try {
      final totalLimit = await _localDataSource.getTotalMonthlyLimit();
      final currentDashboard = await _dashboardLocalDataSource.getSummary();

      final updatedSummary = DashboardSummaryModel(
        userName: currentDashboard.userName,
        totalBalance: currentDashboard.totalBalance,
        monthlyIncome: currentDashboard.monthlyIncome,
        monthlyExpense: totalExpense,
        savingsAmount: currentDashboard.savingsAmount,
        savingsRatePercentage: currentDashboard.savingsRatePercentage,
        budgetSpentAmount: totalExpense,
        budgetTotalLimit: totalLimit,
        recentTransactions: currentDashboard.recentTransactions,
        aiInsightSummary: currentDashboard.aiInsightSummary,
      );

      await _dashboardLocalDataSource.updateSummary(updatedSummary);
    } catch (_) {}
  }

  @override
  Future<MonthlyBudgetSummaryEntity> getMonthlySummary() async {
    final totalLimit = await _localDataSource.getTotalMonthlyLimit();
    final categoryModels = await _localDataSource.getCategoryBudgets();
    final transactions = await _transactionLocalDataSource.getTransactions();

    double totalExpense = 0;
    for (final tx in transactions) {
      if (tx.type == TransactionType.expense) {
        totalExpense += tx.amount;
      }
    }

    return MonthlyBudgetSummaryEntity(
      totalLimit: totalLimit,
      totalSpent: totalExpense,
      categoryBudgets: categoryModels,
    );
  }

  @override
  Stream<MonthlyBudgetSummaryEntity> watchMonthlySummary() async* {
    yield await getMonthlySummary();

    await for (final _ in _localDataSource.watchCategoryBudgets()) {
      yield await getMonthlySummary();
    }
  }

  @override
  Future<void> setTotalMonthlyLimit(double totalLimit) async {
    await _localDataSource.setTotalMonthlyLimit(totalLimit);
    final summary = await getMonthlySummary();
    await _syncDashboardBudgetCard(summary.totalSpent);
  }

  @override
  Future<BudgetEntity> saveCategoryBudget(BudgetEntity budget) async {
    final model = BudgetModel.fromEntity(budget);
    final saved = await _localDataSource.saveCategoryBudget(model);
    return saved;
  }

  @override
  Future<void> deleteCategoryBudget(String budgetId) async {
    await _localDataSource.deleteCategoryBudget(budgetId);
  }
}
