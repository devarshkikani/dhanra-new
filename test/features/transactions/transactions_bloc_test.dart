import 'package:dhanra_new/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dhanra_new/features/transactions/domain/usecases/create_transaction_usecase.dart';
import 'package:dhanra_new/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:dhanra_new/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:dhanra_new/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:dhanra_new/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:dhanra_new/features/transactions/presentation/bloc/transactions_event.dart';
import 'package:dhanra_new/features/transactions/presentation/bloc/transactions_state.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetTransactionsUseCase implements GetTransactionsUseCase {
  final List<TransactionEntity> transactions = [
    TransactionEntity(
      id: 'tx_1',
      title: 'Salary Deposit',
      amount: 125000,
      type: TransactionType.income,
      date: DateTime.now(),
      accountId: 'acc_1',
      accountName: 'HDFC Bank',
      categoryId: 'cat_salary',
      categoryName: 'Salary',
      categoryIcon: 'work',
      categoryColor: '#00C853',
    ),
    TransactionEntity(
      id: 'tx_2',
      title: 'Starbucks Coffee',
      amount: 450,
      type: TransactionType.expense,
      date: DateTime.now(),
      accountId: 'acc_2',
      accountName: 'Paytm Wallet',
      categoryId: 'cat_food',
      categoryName: 'Food & Dining',
      categoryIcon: 'coffee',
      categoryColor: '#9B5DE5',
    ),
  ];

  @override
  Future<List<TransactionEntity>> call() async => transactions;

  @override
  Stream<List<TransactionEntity>> watch() async* {
    yield transactions;
  }
}

class MockCreateTransactionUseCase implements CreateTransactionUseCase {
  @override
  Future<TransactionEntity> call(TransactionEntity transaction) async =>
      transaction;
}

class MockUpdateTransactionUseCase implements UpdateTransactionUseCase {
  @override
  Future<TransactionEntity> call(TransactionEntity transaction) async =>
      transaction;
}

class MockDeleteTransactionUseCase implements DeleteTransactionUseCase {
  @override
  Future<void> call(String transactionId) async {}
}

void main() {
  late TransactionsBloc bloc;
  late MockGetTransactionsUseCase mockGetUseCase;

  setUp(() {
    mockGetUseCase = MockGetTransactionsUseCase();
    bloc = TransactionsBloc(
      getTransactionsUseCase: mockGetUseCase,
      createTransactionUseCase: MockCreateTransactionUseCase(),
      updateTransactionUseCase: MockUpdateTransactionUseCase(),
      deleteTransactionUseCase: MockDeleteTransactionUseCase(),
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('TransactionsBloc Unit Tests', () {
    test(
        'initial state transitions to TransactionsLoadedState from live stream listener',
        () async {
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, isA<TransactionsLoadedState>());
    });

    test('switches filter type correctly', () async {
      bloc.add(const LoadTransactionsEvent());
      await Future<void>.delayed(Duration.zero);

      bloc.add(const TransactionTypeFilterChangedEvent('EXPENSE'));
      await Future<void>.delayed(Duration.zero);

      final state = bloc.state as TransactionsLoadedState;
      expect(state.selectedFilter, 'EXPENSE');
      expect(state.filteredTransactions.length, 1);
      expect(state.filteredTransactions.first.title, 'Starbucks Coffee');
    });

    test('filters transactions by search query', () async {
      bloc.add(const LoadTransactionsEvent());
      await Future<void>.delayed(Duration.zero);

      bloc.add(const TransactionSearchQueryChangedEvent('salary'));
      await Future<void>.delayed(Duration.zero);

      final state = bloc.state as TransactionsLoadedState;
      expect(state.filteredTransactions.length, 1);
      expect(state.filteredTransactions.first.title, 'Salary Deposit');
    });
  });
}
