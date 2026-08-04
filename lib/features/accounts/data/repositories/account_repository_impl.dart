import 'package:dhanra_new/features/accounts/data/datasources/account_local_data_source.dart';
import 'package:dhanra_new/features/accounts/data/models/account_model.dart';
import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:dhanra_new/features/accounts/domain/repositories/account_repository.dart';
import 'package:dhanra_new/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:dhanra_new/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(
    this._localDataSource,
    this._dashboardLocalDataSource,
  ) {
    // Listen to account changes and update Home Dashboard total balance automatically
    _localDataSource.watchAccounts().listen(_syncDashboardBalance);
  }

  final AccountLocalDataSource _localDataSource;
  final DashboardLocalDataSource _dashboardLocalDataSource;

  Future<void> _syncDashboardBalance(List<AccountModel> accounts) async {
    try {
      final currentDashboard = await _dashboardLocalDataSource.getSummary();
      final newTotalBalance = accounts.fold<double>(
        0,
        (sum, item) => sum + item.balance,
      );

      final updatedDashboard = DashboardSummaryModel(
        userName: currentDashboard.userName,
        totalBalance: newTotalBalance,
        monthlyIncome: currentDashboard.monthlyIncome,
        monthlyExpense: currentDashboard.monthlyExpense,
        savingsAmount: currentDashboard.savingsAmount,
        savingsRatePercentage: currentDashboard.savingsRatePercentage,
        budgetSpentAmount: currentDashboard.budgetSpentAmount,
        budgetTotalLimit: currentDashboard.budgetTotalLimit,
        recentTransactions: currentDashboard.recentTransactions,
        aiInsightSummary: currentDashboard.aiInsightSummary,
      );

      await _dashboardLocalDataSource.updateSummary(updatedDashboard);
    } catch (_) {}
  }

  @override
  Future<List<AccountEntity>> getAccounts() async {
    return _localDataSource.getAccounts();
  }

  @override
  Stream<List<AccountEntity>> watchAccounts() {
    return _localDataSource.watchAccounts();
  }

  @override
  Future<AccountEntity> createAccount(AccountEntity account) async {
    final model = AccountModel.fromEntity(account);
    return _localDataSource.createAccount(model);
  }

  @override
  Future<AccountEntity> updateAccount(AccountEntity account) async {
    final model = AccountModel.fromEntity(account);
    return _localDataSource.updateAccount(model);
  }

  @override
  Future<void> deleteAccount(String accountId) async {
    return _localDataSource.deleteAccount(accountId);
  }

  @override
  Future<void> transferFunds({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
  }) async {
    return _localDataSource.transferFunds(
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      amount: amount,
    );
  }
}
