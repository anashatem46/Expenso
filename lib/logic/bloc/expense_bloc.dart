import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/api/notion_api_service.dart';
import '../../data/storage/local_storage_service.dart';
import '../../data/services/dummy_data_service.dart';
import '../../data/models/expense.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final NotionApiService _apiService;
  final LocalStorageService _storageService;

  ExpenseBloc({
    required NotionApiService apiService,
    required LocalStorageService storageService,
  }) : _apiService = apiService,
       _storageService = storageService,
       super(ExpenseState()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpense>(_onAddExpense);
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

      // Use dummy data for testing
      final dummyExpenses = DummyDataService.getDummyExpenses();
      final totalBalance = dummyExpenses.fold(
        0.0,
        (sum, expense) => sum + expense.amount,
      );

      emit(
        state.copyWith(
          status: ExpenseStatus.loaded,
          expenses: dummyExpenses,
          totalBalance: totalBalance,
        ),
      );
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
      emit(state.copyWith(status: ExpenseStatus.loading));

      // Add to local list only (no API call for dummy data)
      final updatedExpenses = List<Expense>.from(state.expenses)
        ..add(event.expense);
      final totalBalance = updatedExpenses.fold(
        0.0,
        (sum, expense) => sum + expense.amount,
      );

      emit(
        state.copyWith(
          status: ExpenseStatus.loaded,
          expenses: updatedExpenses,
          totalBalance: totalBalance,
          isAddModalOpen: false,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ExpenseStatus.error,
          errorMessage: 'Failed to add expense: $e',
        ),
      );
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ExpenseStatus.loading));

      final updatedExpenses =
          state.expenses.where((e) => e.id != event.expenseId).toList();
      final totalBalance = updatedExpenses.fold(
        0.0,
        (sum, expense) => sum + expense.amount,
      );

      emit(
        state.copyWith(
          status: ExpenseStatus.loaded,
          expenses: updatedExpenses,
          totalBalance: totalBalance,
        ),
      );
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
