import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:dhanra_new/features/accounts/domain/repositories/account_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetAccountsUseCase {
  const GetAccountsUseCase(this._repository);

  final AccountRepository _repository;

  Future<List<AccountEntity>> call() async {
    return _repository.getAccounts();
  }

  Stream<List<AccountEntity>> watch() {
    return _repository.watchAccounts();
  }
}
