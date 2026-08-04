import 'package:dhanra_new/features/accounts/domain/repositories/account_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteAccountUseCase {
  const DeleteAccountUseCase(this._repository);

  final AccountRepository _repository;

  Future<void> call(String accountId) async {
    return _repository.deleteAccount(accountId);
  }
}
