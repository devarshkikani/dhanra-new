import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AccountsState extends Equatable {
  const AccountsState();

  @override
  List<Object?> get props => [];
}

class AccountsInitialState extends AccountsState {
  const AccountsInitialState();
}

class AccountsLoadingState extends AccountsState {
  const AccountsLoadingState();
}

class AccountsLoadedState extends AccountsState {
  const AccountsLoadedState(this.accounts);

  final List<AccountEntity> accounts;

  double get netWorth => accounts.fold(0, (sum, item) => sum + item.balance);

  @override
  List<Object?> get props => [accounts];
}

class AccountsErrorState extends AccountsState {
  const AccountsErrorState(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
