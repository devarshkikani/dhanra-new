import 'dart:async';
import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:dhanra_new/features/accounts/domain/usecases/create_account_usecase.dart';
import 'package:dhanra_new/features/accounts/domain/usecases/delete_account_usecase.dart';
import 'package:dhanra_new/features/accounts/domain/usecases/get_accounts_usecase.dart';
import 'package:dhanra_new/features/accounts/domain/usecases/transfer_funds_usecase.dart';
import 'package:dhanra_new/features/accounts/domain/usecases/update_account_usecase.dart';
import 'package:dhanra_new/features/accounts/presentation/bloc/accounts_event.dart';
import 'package:dhanra_new/features/accounts/presentation/bloc/accounts_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc({
    required GetAccountsUseCase getAccountsUseCase,
    required CreateAccountUseCase createAccountUseCase,
    required UpdateAccountUseCase updateAccountUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required TransferFundsUseCase transferFundsUseCase,
  })  : _getAccountsUseCase = getAccountsUseCase,
        _createAccountUseCase = createAccountUseCase,
        _updateAccountUseCase = updateAccountUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _transferFundsUseCase = transferFundsUseCase,
        super(const AccountsInitialState()) {
    on<LoadAccountsEvent>(_onLoadAccounts);
    on<AccountsUpdatedEvent>(_onAccountsUpdated);
    on<CreateAccountRequestedEvent>(_onCreateAccount);
    on<UpdateAccountRequestedEvent>(_onUpdateAccount);
    on<DeleteAccountRequestedEvent>(_onDeleteAccount);
    on<TransferFundsRequestedEvent>(_onTransferFunds);

    _accountsSubscription = _getAccountsUseCase.watch().listen(
      (accounts) {
        add(AccountsUpdatedEvent(accounts));
      },
    );
  }

  final GetAccountsUseCase _getAccountsUseCase;
  final CreateAccountUseCase _createAccountUseCase;
  final UpdateAccountUseCase _updateAccountUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final TransferFundsUseCase _transferFundsUseCase;

  StreamSubscription<List<AccountEntity>>? _accountsSubscription;

  Future<void> _onLoadAccounts(
    LoadAccountsEvent event,
    Emitter<AccountsState> emit,
  ) async {
    emit(const AccountsLoadingState());
    try {
      final accounts = await _getAccountsUseCase();
      emit(AccountsLoadedState(accounts));
    } catch (e) {
      emit(AccountsErrorState(e.toString()));
    }
  }

  void _onAccountsUpdated(
    AccountsUpdatedEvent event,
    Emitter<AccountsState> emit,
  ) {
    emit(AccountsLoadedState(event.accounts));
  }

  Future<void> _onCreateAccount(
    CreateAccountRequestedEvent event,
    Emitter<AccountsState> emit,
  ) async {
    try {
      await _createAccountUseCase(event.account);
    } catch (e) {
      emit(AccountsErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateAccount(
    UpdateAccountRequestedEvent event,
    Emitter<AccountsState> emit,
  ) async {
    try {
      await _updateAccountUseCase(event.account);
    } catch (e) {
      emit(AccountsErrorState(e.toString()));
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccountRequestedEvent event,
    Emitter<AccountsState> emit,
  ) async {
    try {
      await _deleteAccountUseCase(event.accountId);
    } catch (e) {
      emit(AccountsErrorState(e.toString()));
    }
  }

  Future<void> _onTransferFunds(
    TransferFundsRequestedEvent event,
    Emitter<AccountsState> emit,
  ) async {
    try {
      await _transferFundsUseCase(
        fromAccountId: event.fromAccountId,
        toAccountId: event.toAccountId,
        amount: event.amount,
      );
    } catch (e) {
      emit(AccountsErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _accountsSubscription?.cancel();
    return super.close();
  }
}
