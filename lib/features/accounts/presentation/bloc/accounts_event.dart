import 'package:dhanra_new/features/accounts/domain/entities/account_entity.dart';
import 'package:equatable/equatable.dart';

abstract class AccountsEvent extends Equatable {
  const AccountsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAccountsEvent extends AccountsEvent {
  const LoadAccountsEvent();
}

class AccountsUpdatedEvent extends AccountsEvent {
  const AccountsUpdatedEvent(this.accounts);

  final List<AccountEntity> accounts;

  @override
  List<Object?> get props => [accounts];
}

class CreateAccountRequestedEvent extends AccountsEvent {
  const CreateAccountRequestedEvent(this.account);

  final AccountEntity account;

  @override
  List<Object?> get props => [account];
}

class UpdateAccountRequestedEvent extends AccountsEvent {
  const UpdateAccountRequestedEvent(this.account);

  final AccountEntity account;

  @override
  List<Object?> get props => [account];
}

class DeleteAccountRequestedEvent extends AccountsEvent {
  const DeleteAccountRequestedEvent(this.accountId);

  final String accountId;

  @override
  List<Object?> get props => [accountId];
}

class TransferFundsRequestedEvent extends AccountsEvent {
  const TransferFundsRequestedEvent({
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
  });

  final String fromAccountId;
  final String toAccountId;
  final double amount;

  @override
  List<Object?> get props => [fromAccountId, toAccountId, amount];
}
