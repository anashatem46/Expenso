import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/account_service.dart';
import 'account_event.dart';
import 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(const AccountState()) {
    on<LoadAccounts>(_onLoadAccounts);
    on<AddAccount>(_onAddAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<DeleteAccount>(_onDeleteAccount);
    on<UpdateAccountBalance>(_onUpdateAccountBalance);
    on<SelectAccount>(_onSelectAccount);
  }

  Future<void> _onLoadAccounts(
    LoadAccounts event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(status: AccountStatus.loading));

    try {
      final accounts = AccountService.getAllAccounts();
      emit(
        state.copyWith(
          status: AccountStatus.success,
          accounts: accounts,
          selectedAccountId: accounts.isNotEmpty ? accounts.first.id : null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: 'Failed to load accounts: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onAddAccount(
    AddAccount event,
    Emitter<AccountState> emit,
  ) async {
    try {
      AccountService.addAccount(event.account);
      final accounts = AccountService.getAllAccounts();
      emit(state.copyWith(status: AccountStatus.success, accounts: accounts));
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: 'Failed to add account: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUpdateAccount(
    UpdateAccount event,
    Emitter<AccountState> emit,
  ) async {
    try {
      AccountService.updateAccount(event.account);
      final accounts = AccountService.getAllAccounts();
      emit(state.copyWith(status: AccountStatus.success, accounts: accounts));
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: 'Failed to update account: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<AccountState> emit,
  ) async {
    try {
      AccountService.removeAccount(event.accountId);
      final accounts = AccountService.getAllAccounts();

      // If the deleted account was selected, select another one
      String? newSelectedId = state.selectedAccountId;
      if (state.selectedAccountId == event.accountId) {
        newSelectedId = accounts.isNotEmpty ? accounts.first.id : null;
      }

      emit(
        state.copyWith(
          status: AccountStatus.success,
          accounts: accounts,
          selectedAccountId: newSelectedId,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: 'Failed to delete account: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUpdateAccountBalance(
    UpdateAccountBalance event,
    Emitter<AccountState> emit,
  ) async {
    try {
      AccountService.updateAccountBalance(event.accountId, event.amount);
      final accounts = AccountService.getAllAccounts();
      emit(state.copyWith(status: AccountStatus.success, accounts: accounts));
    } catch (e) {
      emit(
        state.copyWith(
          status: AccountStatus.failure,
          errorMessage: 'Failed to update account balance: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onSelectAccount(
    SelectAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(state.copyWith(selectedAccountId: event.accountId));
  }
}
