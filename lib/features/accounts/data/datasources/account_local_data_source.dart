import 'dart:async';
import 'package:dhanra_new/features/accounts/data/models/account_model.dart';

import 'package:injectable/injectable.dart';

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
  AccountLocalDataSourceImpl();

  final List<AccountModel> _accounts = [];
  final StreamController<List<AccountModel>> _controller =
      StreamController<List<AccountModel>>.broadcast();

  void _notifyListeners() {
    _controller.add(List.unmodifiable(_accounts));
  }

  @override
  Future<List<AccountModel>> getAccounts() async {
    return List.unmodifiable(_accounts);
  }

  @override
  Stream<List<AccountModel>> watchAccounts() async* {
    yield List.unmodifiable(_accounts);
    yield* _controller.stream;
  }

  @override
  Future<AccountModel> createAccount(AccountModel account) async {
    _accounts.add(account);
    _notifyListeners();
    return account;
  }

  @override
  Future<AccountModel> updateAccount(AccountModel account) async {
    final index = _accounts.indexWhere((a) => a.id == account.id);
    if (index != -1) {
      _accounts[index] = account;
      _notifyListeners();
    }
    return account;
  }

  @override
  Future<void> deleteAccount(String accountId) async {
    _accounts.removeWhere((a) => a.id == accountId);
    _notifyListeners();
  }

  @override
  Future<void> transferFunds({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
  }) async {
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

      _notifyListeners();
    }
  }
}
