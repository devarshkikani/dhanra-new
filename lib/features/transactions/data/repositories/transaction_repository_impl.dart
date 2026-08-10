import 'package:dhanra_new/features/accounts/data/datasources/account_local_data_source.dart';
import 'package:dhanra_new/features/accounts/data/models/account_model.dart';
import 'package:dhanra_new/features/budgets/data/datasources/budget_local_data_source.dart';
import 'package:dhanra_new/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:dhanra_new/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:dhanra_new/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:dhanra_new/features/transactions/data/models/transaction_model.dart';
import 'package:dhanra_new/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dhanra_new/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(
    this._localDataSource,
    this._accountLocalDataSource,
    this._dashboardLocalDataSource,
    this._budgetLocalDataSource,
  ) {
    _localDataSource.watchTransactions().listen(_syncAccountAndDashboard);
  }

  final TransactionLocalDataSource _localDataSource;
  final AccountLocalDataSource _accountLocalDataSource;
  final DashboardLocalDataSource _dashboardLocalDataSource;
  final BudgetLocalDataSource _budgetLocalDataSource;

  Future<void> _syncAccountAndDashboard(
      List<TransactionModel> transactions) async {
    try {
      double totalIncome = 0;
      double totalExpense = 0;

      final recentDashboardList = <DashboardRecentTransactionModel>[];

      for (final tx in transactions.take(5)) {
        recentDashboardList.add(
          DashboardRecentTransactionModel(
            id: tx.id,
            title: tx.title,
            category: tx.categoryName,
            amount: tx.amount,
            date:
                '${tx.date.day.toString().padLeft(2, '0')} ${_monthAbbrev(tx.date.month)}',
            isCredit: tx.type == TransactionType.income,
          ),
        );
      }

      for (final tx in transactions) {
        if (tx.type == TransactionType.income) {
          totalIncome += tx.amount;
        } else if (tx.type == TransactionType.expense) {
          totalExpense += tx.amount;
        }
      }

      final accounts = await _accountLocalDataSource.getAccounts();
      final totalNetBalance = accounts.fold<double>(
        0,
        (sum, item) => sum + item.balance,
      );

      final savings = totalIncome - totalExpense;
      final savingsRate =
          totalIncome > 0 ? (savings / totalIncome) * 100 : 0.0;

      final currentDashboard = await _dashboardLocalDataSource.getSummary();
      final effectiveBudgetLimit =
          await _budgetLocalDataSource.getEffectiveTotalMonthlyLimit();

      final updatedSummary = DashboardSummaryModel(
        userName: currentDashboard.userName,
        totalBalance: totalNetBalance,
        monthlyIncome: totalIncome,
        monthlyExpense: totalExpense,
        savingsAmount: savings > 0 ? savings : 0,
        savingsRatePercentage: savingsRate > 0 ? savingsRate : 0,
        budgetSpentAmount: totalExpense,
        budgetTotalLimit: effectiveBudgetLimit > 0
            ? effectiveBudgetLimit
            : currentDashboard.budgetTotalLimit,
        recentTransactions: recentDashboardList,
        aiInsightSummary:
            'You saved ${savingsRate.toStringAsFixed(1)}% of your income this month.',
      );

      await _dashboardLocalDataSource.updateSummary(updatedSummary);
    } catch (_) {}
  }

  String _monthAbbrev(int month) {
    const months = [
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
    return months[(month - 1).clamp(0, 11)];
  }

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    return _localDataSource.getTransactions();
  }

  @override
  Stream<List<TransactionEntity>> watchTransactions() {
    return _localDataSource.watchTransactions();
  }

  @override
  Future<TransactionEntity> createTransaction(
      TransactionEntity transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    final created = await _localDataSource.createTransaction(model);

    final accounts = await _accountLocalDataSource.getAccounts();
    final accountIndex =
        accounts.indexWhere((a) => a.id == transaction.accountId);
    if (accountIndex != -1) {
      final account = accounts[accountIndex];
      double newBalance = account.balance;
      if (transaction.type == TransactionType.income) {
        newBalance += transaction.amount;
      } else if (transaction.type == TransactionType.expense) {
        newBalance -= transaction.amount;
      }
      await _accountLocalDataSource.updateAccount(
        AccountModel.fromEntity(account.copyWith(balance: newBalance)),
      );
    }

    if (transaction.type == TransactionType.transfer &&
        transaction.toAccountId != null) {
      final toAccountIndex =
          accounts.indexWhere((a) => a.id == transaction.toAccountId);
      if (toAccountIndex != -1) {
        final toAccount = accounts[toAccountIndex];
        await _accountLocalDataSource.updateAccount(
          AccountModel.fromEntity(
            toAccount.copyWith(
              balance: toAccount.balance + transaction.amount,
            ),
          ),
        );
      }
    }

    return created;
  }

  @override
  Future<TransactionEntity> updateTransaction(
      TransactionEntity transaction) async {
    final model = TransactionModel.fromEntity(transaction);
    final updated = await _localDataSource.updateTransaction(model);
    return updated;
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    await _localDataSource.deleteTransaction(transactionId);
  }
}
