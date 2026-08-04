import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';

abstract class AccountRepository {
  Future<List<AccountEntity>> getAccounts();
  Stream<List<AccountEntity>> watchAccounts();
  Future<AccountEntity> createAccount(AccountEntity account);
  Future<AccountEntity> updateAccount(AccountEntity account);
  Future<void> deleteAccount(String accountId);
  Future<void> transferFunds({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
  });
}
