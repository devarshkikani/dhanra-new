import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:dhanra_new/features/accounts/domain/repositories/account_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CreateAccountUseCase {
  const CreateAccountUseCase(this._repository);

  final AccountRepository _repository;

  Future<AccountEntity> call(AccountEntity account) async {
    return _repository.createAccount(account);
  }
}
