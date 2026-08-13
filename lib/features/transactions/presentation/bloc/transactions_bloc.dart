import 'dart:async';
import 'package:dhanra_new/features/categories/domain/usecases/get_categories_usecase.dart';
import 'package:dhanra_new/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dhanra_new/features/transactions/domain/usecases/create_transaction_usecase.dart';
import 'package:dhanra_new/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:dhanra_new/features/transactions/domain/usecases/get_transactions_usecase.dart';
import 'package:dhanra_new/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:dhanra_new/features/transactions/presentation/bloc/transactions_event.dart';
import 'package:dhanra_new/features/transactions/presentation/bloc/transactions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc({
    required GetTransactionsUseCase getTransactionsUseCase,
    required CreateTransactionUseCase createTransactionUseCase,
    required UpdateTransactionUseCase updateTransactionUseCase,
    required DeleteTransactionUseCase deleteTransactionUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
  })  : _getTransactionsUseCase = getTransactionsUseCase,
        _createTransactionUseCase = createTransactionUseCase,
        _updateTransactionUseCase = updateTransactionUseCase,
        _deleteTransactionUseCase = deleteTransactionUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        super(const TransactionsInitialState()) {
    on<LoadTransactionsEvent>(_onLoadTransactions);
    on<TransactionsUpdatedEvent>(_onTransactionsUpdated);
    on<TransactionTypeFilterChangedEvent>(_onFilterChanged);
    on<TransactionSearchQueryChangedEvent>(_onSearchQueryChanged);
    on<ApplyAdvancedTransactionFiltersEvent>(_onApplyAdvancedFilters);
    on<CreateTransactionRequestedEvent>(_onCreateTransaction);
    on<UpdateTransactionRequestedEvent>(_onUpdateTransaction);
    on<DeleteTransactionRequestedEvent>(_onDeleteTransaction);

    _subscription = _getTransactionsUseCase.watch().listen(
      (transactions) {
        add(TransactionsUpdatedEvent(transactions));
      },
    );
  }

  final GetTransactionsUseCase _getTransactionsUseCase;
  final CreateTransactionUseCase _createTransactionUseCase;
  final UpdateTransactionUseCase _updateTransactionUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;

  StreamSubscription<List<TransactionEntity>>? _subscription;

  Future<void> _onLoadTransactions(
    LoadTransactionsEvent event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(const TransactionsLoadingState());
    try {
      final transactions = await _getTransactionsUseCase();
      final categories = await _getCategoriesUseCase();
      emit(TransactionsLoadedState(
        allTransactions: transactions,
        categories: categories,
      ));
    } catch (e) {
      emit(TransactionsErrorState(e.toString()));
    }
  }

  Future<void> _onTransactionsUpdated(
    TransactionsUpdatedEvent event,
    Emitter<TransactionsState> emit,
  ) async {
    final categories = await _getCategoriesUseCase();
    if (state is TransactionsLoadedState) {
      final current = state as TransactionsLoadedState;
      emit(current.copyWith(
        allTransactions: event.transactions,
        categories: categories,
      ));
    } else {
      emit(TransactionsLoadedState(
        allTransactions: event.transactions,
        categories: categories,
      ));
    }
  }

  void _onFilterChanged(
    TransactionTypeFilterChangedEvent event,
    Emitter<TransactionsState> emit,
  ) {
    if (state is TransactionsLoadedState) {
      final current = state as TransactionsLoadedState;
      emit(current.copyWith(selectedFilter: event.selectedFilter));
    }
  }

  void _onSearchQueryChanged(
    TransactionSearchQueryChangedEvent event,
    Emitter<TransactionsState> emit,
  ) {
    if (state is TransactionsLoadedState) {
      final current = state as TransactionsLoadedState;
      emit(current.copyWith(searchQuery: event.searchQuery));
    }
  }

  void _onApplyAdvancedFilters(
    ApplyAdvancedTransactionFiltersEvent event,
    Emitter<TransactionsState> emit,
  ) {
    if (state is TransactionsLoadedState) {
      final current = state as TransactionsLoadedState;
      emit(current.copyWith(
        selectedFilter: event.selectedFilter,
        clearAccountId: event.selectedAccountId == null,
        selectedAccountId: event.selectedAccountId,
        clearCategoryId: event.selectedCategoryId == null,
        selectedCategoryId: event.selectedCategoryId,
        sortBy: event.sortBy,
      ));
    }
  }

  Future<void> _onCreateTransaction(
    CreateTransactionRequestedEvent event,
    Emitter<TransactionsState> emit,
  ) async {
    try {
      await _createTransactionUseCase(event.transaction);
    } catch (e) {
      emit(TransactionsErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateTransaction(
    UpdateTransactionRequestedEvent event,
    Emitter<TransactionsState> emit,
  ) async {
    try {
      await _updateTransactionUseCase(event.transaction);
    } catch (e) {
      emit(TransactionsErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionRequestedEvent event,
    Emitter<TransactionsState> emit,
  ) async {
    try {
      await _deleteTransactionUseCase(event.transactionId);
    } catch (e) {
      emit(TransactionsErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
