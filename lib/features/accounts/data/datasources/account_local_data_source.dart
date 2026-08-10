import 'dart:async';
import 'dart:convert';
import 'package:dhanra_new/features/accounts/data/models/account_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AccountLocalDataSource {
  Future<List<AccountModel>> getAccounts();
  Stream<List<AccountModel>> watchAccounts();
  Future<AccountModel> createAccount(AccountModel account);
  Future<AccountModel> updateAccount(AccountModel account);
  Future<void> deleteAccount(String accountId);
  Future<void> transferFunds({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
  });
}

@LazySingleton(as: AccountLocalDataSource)
class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  AccountLocalDataSourceImpl() {
    _initFromPrefs();
  }

  static const _storageKey = 'dhanra_accounts_v1';
  final List<AccountModel> _accounts = [];
  final StreamController<List<AccountModel>> _controller =
      StreamController<List<AccountModel>>.broadcast();
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
        _accounts.clear();
        _accounts.addAll(
          decoded.map((e) => AccountModel.fromJson(e as Map<String, dynamic>)),
        );
      }
    } catch (_) {
      // Fallback gracefully on parse error
    } finally {
      _isLoaded = true;
      _initCompleter?.complete();
      _notifyListeners();
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawJson = jsonEncode(_accounts.map((a) => a.toJson()).toList());
      await prefs.setString(_storageKey, rawJson);
    } catch (_) {}
  }

  void _notifyListeners() {
    _controller.add(List.unmodifiable(_accounts));
  }

  @override
  Future<List<AccountModel>> getAccounts() async {
    await _initFromPrefs();
    return List.unmodifiable(_accounts);
  }

  @override
  Stream<List<AccountModel>> watchAccounts() async* {
    await _initFromPrefs();
    yield List.unmodifiable(_accounts);
    yield* _controller.stream;
  }

  @override
  Future<AccountModel> createAccount(AccountModel account) async {
    await _initFromPrefs();
    _accounts.add(account);
    await _saveToPrefs();
    _notifyListeners();
    return account;
  }

  @override
  Future<AccountModel> updateAccount(AccountModel account) async {
    await _initFromPrefs();
    final index = _accounts.indexWhere((a) => a.id == account.id);
    if (index != -1) {
      _accounts[index] = account;
      await _saveToPrefs();
      _notifyListeners();
    }
    return account;
  }

  @override
  Future<void> deleteAccount(String accountId) async {
    await _initFromPrefs();
    _accounts.removeWhere((a) => a.id == accountId);
    await _saveToPrefs();
    _notifyListeners();
  }

  @override
  Future<void> transferFunds({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
  }) async {
    await _initFromPrefs();
    final fromIndex = _accounts.indexWhere((a) => a.id == fromAccountId);
    final toIndex = _accounts.indexWhere((a) => a.id == toAccountId);

    if (fromIndex != -1 && toIndex != -1) {
      final fromAcc = _accounts[fromIndex];
      final toAcc = _accounts[toIndex];

      _accounts[fromIndex] = AccountModel.fromEntity(
        fromAcc.copyWith(balance: fromAcc.balance - amount),
      );
      _accounts[toIndex] = AccountModel.fromEntity(
        toAcc.copyWith(balance: toAcc.balance + amount),
      );

      await _saveToPrefs();
      _notifyListeners();
    }
  }
}
