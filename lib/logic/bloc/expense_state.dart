import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/models/expense.dart';

enum ExpenseStatus { initial, loading, loaded, error }

class ExpenseState extends Equatable {
  final ExpenseStatus status;
  final List<Expense> expenses;
  final String? errorMessage;
  final DateTime selectedMonth;
  final bool isAddModalOpen;
  final double totalBalance;

  ExpenseState({
    this.status = ExpenseStatus.initial,
    this.expenses = const [],
    this.errorMessage,
    DateTime? selectedMonth,
    this.isAddModalOpen = false,
    this.totalBalance = 0.0,
  }) : selectedMonth = selectedMonth ?? DateTime.now();

  ExpenseState copyWith({
    ExpenseStatus? status,
    List<Expense>? expenses,
    String? errorMessage,
    DateTime? selectedMonth,
    bool? isAddModalOpen,
    double? totalBalance,
  }) {
    return ExpenseState(
      status: status ?? this.status,
      expenses: expenses ?? this.expenses,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      isAddModalOpen: isAddModalOpen ?? this.isAddModalOpen,
      totalBalance: totalBalance ?? this.totalBalance,
    );
  }

  List<Expense> get expensesForSelectedMonth {
    return expenses.where((expense) {
      return expense.date.year == selectedMonth.year &&
          expense.date.month == selectedMonth.month;
    }).toList();
  }

  double get totalExpenses {
    return expensesForSelectedMonth
        .where((expense) => expense.amount < 0)
        .fold(0.0, (sum, expense) => sum + expense.amount.abs());
  }

  double get totalIncome {
    return expensesForSelectedMonth
        .where((expense) => expense.amount > 0)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  Map<String, double> get expensesByCategory {
    final Map<String, double> categoryTotals = {};
    for (final expense in expensesForSelectedMonth) {
      if (expense.amount < 0) {
        categoryTotals[expense.category] =
            (categoryTotals[expense.category] ?? 0) + expense.amount.abs();
      }
    }
    return categoryTotals;
  }

  List<FlSpot> get chartData {
    final spots = <FlSpot>[];
    final sortedExpenses = List<Expense>.from(expensesForSelectedMonth);
    sortedExpenses.sort((a, b) => a.date.compareTo(b.date));

    double cumulative = 0.0;
    for (int i = 0; i < sortedExpenses.length; i++) {
      cumulative += sortedExpenses[i].amount;
      spots.add(FlSpot(i.toDouble(), cumulative));
    }

    return spots;
  }

  @override
  List<Object?> get props => [
    status,
    expenses,
    errorMessage,
    selectedMonth,
    isAddModalOpen,
    totalBalance,
  ];
}
