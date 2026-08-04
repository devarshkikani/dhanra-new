import 'package:dhanra_new/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dhanra_new/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetTransactionsUseCase {
  const GetTransactionsUseCase(this._repository);

  final TransactionRepository _repository;

  Future<List<TransactionEntity>> call() async {
    return _repository.getTransactions();
  }

  Stream<List<TransactionEntity>> watch() {
    return _repository.watchTransactions();
  }
}
