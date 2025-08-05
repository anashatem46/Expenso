import 'package:equatable/equatable.dart';
import '../../data/models/expense.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

class LoadExpenses extends ExpenseEvent {
  const LoadExpenses();
}

class AddExpense extends ExpenseEvent {
  final Expense expense;

  const AddExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class UpdateExpense extends ExpenseEvent {
  final Expense expense;

  const UpdateExpense(this.expense);

  @override
  List<Object?> get props => [expense];
}

class DeleteExpense extends ExpenseEvent {
  final String expenseId;

  const DeleteExpense(this.expenseId);

  @override
  List<Object?> get props => [expenseId];
}

class RefreshExpenses extends ExpenseEvent {
  const RefreshExpenses();
}

class SelectMonth extends ExpenseEvent {
  final DateTime month;

  const SelectMonth(this.month);

  @override
  List<Object?> get props => [month];
}

class ToggleAddModal extends ExpenseEvent {
  final bool isOpen;

  const ToggleAddModal(this.isOpen);

  @override
  List<Object?> get props => [isOpen];
}
