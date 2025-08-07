import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/account_repository.dart';
import 'account_event.dart';
import 'account_state.dart';
import '../../data/models/account.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository _accountRepository;

  AccountBloc({required AccountRepository accountRepository})
    : _accountRepository = accountRepository,
      super(const AccountState()) {
    on<LoadAccounts>(_onLoadAccounts);
    on<AddAccount>(_onAddAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<SelectAccount>(_onSelectAccount);
  }

  Future<void> _onLoadAccounts(
    LoadAccounts event,
    Emitter<AccountState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AccountStatus.loading));
      final accounts = await _accountRepository.getAccounts();
      final totalBalance = accounts.fold(
        0.0,
        (sum, account) => sum + account.balance,
      );
      emit(
        state.copyWith(
          status: AccountStatus.success,
          accounts: accounts,
          selectedAccountId: accounts.isNotEmpty ? accounts.first.id : null,
          totalBalance: totalBalance,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: 'Failed to load accounts: $e',
        ),
      );
    }
  }

  Future<void> _onAddAccount(
    AddAccount event,
    Emitter<AccountState> emit,
  ) async {
    try {
      await _accountRepository.addAccount(event.account);
      add(const LoadAccounts());
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: 'Failed to add account: $e',
        ),
      );
    }
  }

  Future<void> _onUpdateAccount(
    UpdateAccount event,
    Emitter<AccountState> emit,
  ) async {
    try {
      await _accountRepository.updateAccount(event.account);
      add(const LoadAccounts());
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: 'Failed to update account: $e',
        ),
      );
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<AccountState> emit,
  ) async {
    try {
      await _accountRepository.deleteAccount(event.accountId);
      add(const LoadAccounts());
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: 'Failed to delete account: $e',
        ),
      );
    }
  }

  void _onSelectAccount(SelectAccount event, Emitter<AccountState> emit) {
    emit(state.copyWith(selectedAccountId: event.accountId));
  }
}
