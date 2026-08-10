import 'dart:async';
import 'dart:convert';
import 'package:dhanra_new/features/transactions/data/models/transaction_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _initFromPrefs();
  }

  static const _storageKey = 'dhanra_transactions_v1';
  final List<TransactionModel> _transactions = [];
  final StreamController<List<TransactionModel>> _controller =
      StreamController<List<TransactionModel>>.broadcast();
  bool _isLoaded = false;
  Completer<void>? _initCompleter;

  Future<void> _initFromPrefs() async {
    if (_isLoaded) return;
    if (_initCompleter != null) return _initCompleter!.future;
    _initCompleter = Completer<void>();

    try {
      final prefs = await SharedPreferences.getInstance();
      final rawJson = prefs.getString(_storageKey);
      if (rawJson != null && rawJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(rawJson) as List<dynamic>;
        _transactions.clear();
        _transactions.addAll(
          decoded.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>)),
        );
        _transactions.sort((a, b) => b.date.compareTo(a.date));
      }
    } catch (_) {
    } finally {
      _isLoaded = true;
      _initCompleter?.complete();
      _notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawJson = jsonEncode(_transactions.map((t) => t.toJson()).toList());
      await prefs.setString(_storageKey, rawJson);
    } catch (_) {}
  }

  void _notifyListeners() {
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    _controller.add(List.unmodifiable(_transactions));
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    await _initFromPrefs();
    return List.unmodifiable(_transactions);
  }

  @override
  Stream<List<TransactionModel>> watchTransactions() async* {
    await _initFromPrefs();
    yield List.unmodifiable(_transactions);
    yield* _controller.stream;
  }

  @override
  Future<TransactionModel> createTransaction(
      TransactionModel transaction) async {
    await _initFromPrefs();
    _transactions.insert(0, transaction);
    await _saveToPrefs();
    _notifyListeners();
    return transaction;
  }

  @override
  Future<TransactionModel> updateTransaction(
      TransactionModel transaction) async {
    await _initFromPrefs();
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      await _saveToPrefs();
      _notifyListeners();
    }
    return transaction;
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    await _initFromPrefs();
    _transactions.removeWhere((t) => t.id == transactionId);
    await _saveToPrefs();
    _notifyListeners();
  }
}
