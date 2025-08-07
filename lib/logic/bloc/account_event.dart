import 'package:equatable/equatable.dart';
import '../../data/models/account.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class LoadAccounts extends AccountEvent {
  const LoadAccounts();
}

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

class SelectAccount extends AccountEvent {
  final String accountId;

  const SelectAccount(this.accountId);

  @override
  List<Object> get props => [accountId];
}
