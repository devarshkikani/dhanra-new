import 'package:dhanra_new/features/accounts/domain/repositories/account_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TransferFundsUseCase {
  const TransferFundsUseCase(this._repository);

  final AccountRepository _repository;

  Future<void> call({
    required String fromAccountId,
    required String toAccountId,
    required double amount,
  }) async {
    return _repository.transferFunds(
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      amount: amount,
    );
  }
}
