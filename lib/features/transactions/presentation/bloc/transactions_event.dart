import 'package:dhanra_new/features/transactions/domain/entities/transaction_entity.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactionsEvent extends TransactionsEvent {
  const LoadTransactionsEvent();
}

class TransactionsUpdatedEvent extends TransactionsEvent {
  const TransactionsUpdatedEvent(this.transactions);

  final List<TransactionEntity> transactions;

  @override
  List<Object?> get props => [transactions];
}

class TransactionTypeFilterChangedEvent extends TransactionsEvent {
  const TransactionTypeFilterChangedEvent(this.selectedFilter);

  final String selectedFilter; // 'ALL', 'EXPENSE', 'INCOME', 'TRANSFER'

  @override
  List<Object?> get props => [selectedFilter];
}

class TransactionSearchQueryChangedEvent extends TransactionsEvent {
  const TransactionSearchQueryChangedEvent(this.searchQuery);

  final String searchQuery;

  @override
  List<Object?> get props => [searchQuery];
}

class CreateTransactionRequestedEvent extends TransactionsEvent {
  const CreateTransactionRequestedEvent(this.transaction);

  final TransactionEntity transaction;

  @override
  List<Object?> get props => [transaction];
}

class UpdateTransactionRequestedEvent extends TransactionsEvent {
  const UpdateTransactionRequestedEvent(this.transaction);

  final TransactionEntity transaction;

  @override
  List<Object?> get props => [transaction];
}

class DeleteTransactionRequestedEvent extends TransactionsEvent {
  const DeleteTransactionRequestedEvent(this.transactionId);

  final String transactionId;

  @override
  List<Object?> get props => [transactionId];
}
