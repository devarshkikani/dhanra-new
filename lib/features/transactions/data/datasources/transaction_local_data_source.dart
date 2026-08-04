import 'dart:async';
import 'package:dhanra_new/features/transactions/data/models/transaction_model.dart';
import 'package:dhanra_new/features/transactions/domain/entities/transaction_entity.dart';
import 'package:injectable/injectable.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getTransactions();
  Stream<List<TransactionModel>> watchTransactions();
  Future<TransactionModel> createTransaction(TransactionModel transaction);
  Future<TransactionModel> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String transactionId);
}

@LazySingleton(as: TransactionLocalDataSource)
class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  TransactionLocalDataSourceImpl() {
    _initSeedTransactions();
  }

  final List<TransactionModel> _transactions = [];
  final StreamController<List<TransactionModel>> _controller =
      StreamController<List<TransactionModel>>.broadcast();

  void _initSeedTransactions() {
    final now = DateTime.now();

    _transactions.addAll([
      TransactionModel(
        id: 'tx_1',
        title: 'Salary Deposit',
        amount: 125000,
        type: TransactionType.income,
        date: now.subtract(const Duration(days: 3)),
        accountId: 'acc_1',
        accountName: 'HDFC Salary Account',
        categoryId: 'cat_salary',
        categoryName: 'Salary',
        categoryIcon: 'work',
        categoryColor: '#00C853',
        notes: 'August Monthly Salary',
      ),
      TransactionModel(
        id: 'tx_2',
        title: 'Apple Store Purchase',
        amount: 24900,
        type: TransactionType.expense,
        date: now.subtract(const Duration(days: 2)),
        accountId: 'acc_1',
        accountName: 'HDFC Salary Account',
        categoryId: 'cat_shopping',
        categoryName: 'Shopping',
        categoryIcon: 'shopping_bag',
        categoryColor: '#FFA500',
        notes: 'AirPods Pro 2',
      ),
      TransactionModel(
        id: 'tx_3',
        title: 'Starbucks Coffee',
        amount: 450,
        type: TransactionType.expense,
        date: now.subtract(const Duration(days: 1)),
        accountId: 'acc_2',
        accountName: 'Paytm Wallet',
        categoryId: 'cat_food',
        categoryName: 'Food & Dining',
        categoryIcon: 'coffee',
        categoryColor: '#9B5DE5',
      ),
      TransactionModel(
        id: 'tx_4',
        title: 'Grocery Supermarket',
        amount: 3200,
        type: TransactionType.expense,
        date: now.subtract(const Duration(days: 1)),
        accountId: 'acc_1',
        accountName: 'HDFC Salary Account',
        categoryId: 'cat_groceries',
        categoryName: 'Groceries',
        categoryIcon: 'local_grocery_store',
        categoryColor: '#00F5D4',
      ),
      TransactionModel(
        id: 'tx_5',
        title: 'Freelance Design Payment',
        amount: 15000,
        type: TransactionType.income,
        date: now,
        accountId: 'acc_2',
        accountName: 'Paytm Wallet',
        categoryId: 'cat_freelance',
        categoryName: 'Freelance & Business',
        categoryIcon: 'laptop_mac',
        categoryColor: '#00F5D4',
        notes: 'UI/UX Redesign Deposit',
      ),
    ]);
  }

  void _notifyListeners() {
    _controller.add(List.unmodifiable(_transactions));
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    return List.unmodifiable(_transactions);
  }

  @override
  Stream<List<TransactionModel>> watchTransactions() async* {
    yield List.unmodifiable(_transactions);
    yield* _controller.stream;
  }

  @override
  Future<TransactionModel> createTransaction(
      TransactionModel transaction) async {
    _transactions.insert(0, transaction);
    _notifyListeners();
    return transaction;
  }

  @override
  Future<TransactionModel> updateTransaction(
      TransactionModel transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      _notifyListeners();
    }
    return transaction;
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    _transactions.removeWhere((t) => t.id == transactionId);
    _notifyListeners();
  }
}
