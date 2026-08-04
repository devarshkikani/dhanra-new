import 'dart:async';
import 'package:dhanra_new/features/accounts/data/models/account_model.dart';
import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
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
  AccountLocalDataSourceImpl() {
    _initSeedAccounts();
  }

  final List<AccountModel> _accounts = [];
  final StreamController<List<AccountModel>> _controller =
      StreamController<List<AccountModel>>.broadcast();

  void _initSeedAccounts() {
    _accounts.addAll([
      AccountModel(
        id: 'acc_1',
        name: 'HDFC Salary Account',
        type: AccountType.bank,
        balance: 75000,
        currency: 'INR',
        colorHex: '#9B5DE5',
        iconName: 'account_balance',
        accountNumberLast4: '4321',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      AccountModel(
        id: 'acc_2',
        name: 'Paytm Wallet',
        type: AccountType.wallet,
        balance: 4550,
        currency: 'INR',
        colorHex: '#00F5D4',
        iconName: 'account_balance_wallet',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      AccountModel(
        id: 'acc_3',
        name: 'Pocket Cash',
        type: AccountType.cash,
        balance: 5000,
        currency: 'INR',
        colorHex: '#FFA500',
        iconName: 'payments',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ]);
  }

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
