import 'package:dhanra_new/features/accounts/data/datasources/account_local_data_source.dart';
import 'package:dhanra_new/features/accounts/data/models/account_model.dart';
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
  ) {
    _localDataSource.watchTransactions().listen(_syncAccountAndDashboard);
  }

  final TransactionLocalDataSource _localDataSource;
  final AccountLocalDataSource _accountLocalDataSource;
  final DashboardLocalDataSource _dashboardLocalDataSource;

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
      final savingsRate = totalIncome > 0 ? (savings / totalIncome) * 100 : 0.0;

      final currentDashboard = await _dashboardLocalDataSource.getSummary();

      final updatedSummary = DashboardSummaryModel(
        userName: currentDashboard.userName,
        totalBalance: totalNetBalance,
        monthlyIncome: totalIncome,
        monthlyExpense: totalExpense,
        savingsAmount: savings > 0 ? savings : 0,
        savingsRatePercentage: savingsRate > 0 ? savingsRate : 0,
        budgetSpentAmount: totalExpense,
        budgetTotalLimit: currentDashboard.budgetTotalLimit,
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

    // Sync account balance
    final accounts = await _accountLocalDataSource.getAccounts();
    final accIndex = accounts.indexWhere((a) => a.id == transaction.accountId);
    if (accIndex != -1) {
      final acc = accounts[accIndex];
      final newBalance = transaction.type == TransactionType.income
          ? acc.balance + transaction.amount
          : acc.balance - transaction.amount;
      await _accountLocalDataSource.updateAccount(
        AccountModel.fromEntity(acc.copyWith(balance: newBalance)),
      );
    }

    return created;
  }

  @override
  Future<TransactionEntity> updateTransaction(
      TransactionEntity transaction) async {
    final oldTransactions = await _localDataSource.getTransactions();
    final oldTxIndex =
        oldTransactions.indexWhere((t) => t.id == transaction.id);

    if (oldTxIndex != -1) {
      final oldTx = oldTransactions[oldTxIndex];
      final accounts = await _accountLocalDataSource.getAccounts();

      // Revert old transaction effect
      final oldAccIndex = accounts.indexWhere((a) => a.id == oldTx.accountId);
      if (oldAccIndex != -1) {
        final oldAcc = accounts[oldAccIndex];
        final revertedBalance = oldTx.type == TransactionType.income
            ? oldAcc.balance - oldTx.amount
            : oldAcc.balance + oldTx.amount;
        await _accountLocalDataSource.updateAccount(
          AccountModel.fromEntity(oldAcc.copyWith(balance: revertedBalance)),
        );
      }

      // Apply new transaction effect
      final updatedAccounts = await _accountLocalDataSource.getAccounts();
      final newAccIndex =
          updatedAccounts.indexWhere((a) => a.id == transaction.accountId);
      if (newAccIndex != -1) {
        final newAcc = updatedAccounts[newAccIndex];
        final appliedBalance = transaction.type == TransactionType.income
            ? newAcc.balance + transaction.amount
            : newAcc.balance - transaction.amount;
        await _accountLocalDataSource.updateAccount(
          AccountModel.fromEntity(newAcc.copyWith(balance: appliedBalance)),
        );
      }
    }

    final model = TransactionModel.fromEntity(transaction);
    return _localDataSource.updateTransaction(model);
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    final oldTransactions = await _localDataSource.getTransactions();
    final oldTxIndex = oldTransactions.indexWhere((t) => t.id == transactionId);

    if (oldTxIndex != -1) {
      final oldTx = oldTransactions[oldTxIndex];
      final accounts = await _accountLocalDataSource.getAccounts();
      final accIndex = accounts.indexWhere((a) => a.id == oldTx.accountId);

      if (accIndex != -1) {
        final acc = accounts[accIndex];
        final revertedBalance = oldTx.type == TransactionType.income
            ? acc.balance - oldTx.amount
            : acc.balance + oldTx.amount;
        await _accountLocalDataSource.updateAccount(
          AccountModel.fromEntity(acc.copyWith(balance: revertedBalance)),
        );
      }
    }

    return _localDataSource.deleteTransaction(transactionId);
  }
}
