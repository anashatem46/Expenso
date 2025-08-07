import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/expense_repository.dart';
import 'expense_event.dart';
import 'expense_state.dart';
import 'account_bloc.dart';
import 'account_event.dart';
import '../../data/models/expense.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository _expenseRepository;
  final AccountBloc _accountBloc;

  ExpenseBloc({
    required ExpenseRepository expenseRepository,
    required AccountBloc accountBloc,
  }) : _expenseRepository = expenseRepository,
       _accountBloc = accountBloc,
       super(ExpenseState()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpense>(_onAddExpense);
    on<UpdateExpense>(_onUpdateExpense);
    on<DeleteExpense>(_onDeleteExpense);
    on<SelectMonth>(_onSelectMonth);
    on<ToggleAddModal>(_onToggleAddModal);
  }

  Future<void> _onLoadExpenses(
    LoadExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ExpenseStatus.loading));
      final expenses = await _expenseRepository.getExpenses();
      emit(state.copyWith(status: ExpenseStatus.loaded, expenses: expenses));
    } catch (e) {
      emit(
        state.copyWith(
          status: ExpenseStatus.error,
          errorMessage: 'Failed to load expenses: $e',
        ),
      );
    }
  }

  Future<void> _onAddExpense(
    AddExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _expenseRepository.addExpense(event.expense);
      add(const LoadExpenses()); // Reload expenses to reflect the change
      _accountBloc.add(
        const LoadAccounts(),
      ); // Reload accounts to update balance
    } catch (e) {
      emit(
        state.copyWith(
          status: ExpenseStatus.error,
          errorMessage: 'Failed to add expense: $e',
        ),
      );
    }
  }

  Future<void> _onUpdateExpense(
    UpdateExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _expenseRepository.updateExpense(event.expense);
      add(const LoadExpenses()); // Reload expenses
      _accountBloc.add(const LoadAccounts()); // Reload accounts
    } catch (e) {
      emit(
        state.copyWith(
          status: ExpenseStatus.error,
          errorMessage: 'Failed to update expense: $e',
        ),
      );
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      await _expenseRepository.deleteExpense(event.expenseId);
      add(const LoadExpenses()); // Reload expenses
      _accountBloc.add(const LoadAccounts()); // Reload accounts
    } catch (e) {
      emit(
        state.copyWith(
          status: ExpenseStatus.error,
          errorMessage: 'Failed to delete expense: $e',
        ),
      );
    }
  }

  void _onSelectMonth(SelectMonth event, Emitter<ExpenseState> emit) {
    emit(state.copyWith(selectedMonth: event.month));
  }

  void _onToggleAddModal(ToggleAddModal event, Emitter<ExpenseState> emit) {
    emit(state.copyWith(isAddModalOpen: event.isOpen));
  }
}
