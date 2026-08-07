import 'dart:async';
import 'package:dhanra_new/features/transactions/data/models/transaction_model.dart';
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
  TransactionLocalDataSourceImpl();

  final List<TransactionModel> _transactions = [];
  final StreamController<List<TransactionModel>> _controller =
      StreamController<List<TransactionModel>>.broadcast();

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
