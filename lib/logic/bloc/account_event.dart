import 'package:equatable/equatable.dart';
import '../../data/models/account.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class LoadAccounts extends AccountEvent {}

class AddAccount extends AccountEvent {
  final Account account;

  const AddAccount(this.account);

  @override
  List<Object> get props => [account];
}

class UpdateAccount extends AccountEvent {
  final Account account;

  const UpdateAccount(this.account);

  @override
  List<Object> get props => [account];
}

class DeleteAccount extends AccountEvent {
  final String accountId;

  const DeleteAccount(this.accountId);

  @override
  List<Object> get props => [accountId];
}

class UpdateAccountBalance extends AccountEvent {
  final String accountId;
  final double amount;

  const UpdateAccountBalance(this.accountId, this.amount);

  @override
  List<Object> get props => [accountId, amount];
}

class SelectAccount extends AccountEvent {
  final String accountId;

  const SelectAccount(this.accountId);

  @override
  List<Object> get props => [accountId];
}
