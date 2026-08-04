import 'package:dhanra_new/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteTransactionUseCase {
  const DeleteTransactionUseCase(this._repository);

  final TransactionRepository _repository;

  Future<void> call(String transactionId) async {
    return _repository.deleteTransaction(transactionId);
  }
}
