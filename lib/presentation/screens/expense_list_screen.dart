import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/expense_bloc.dart';
import '../../logic/bloc/expense_event.dart';
import '../../logic/bloc/expense_state.dart';
import '../../data/models/expense.dart';
import '../widgets/expense_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as custom;

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  @override
  void initState() {
    super.initState();
    // Load expenses when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseBloc>().add(const LoadExpenses());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenso Tracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ExpenseBloc>().add(const LoadExpenses());
            },
          ),
        ],
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          switch (state.status) {
            case ExpenseStatus.initial:
            case ExpenseStatus.loading:
              return const LoadingWidget();

            case ExpenseStatus.error:
              return custom.ErrorWidget(
                message: state.errorMessage ?? 'An error occurred',
                onRetry:
                    () => context.read<ExpenseBloc>().add(const LoadExpenses()),
              );

            case ExpenseStatus.loaded:
              return _buildExpenseList(state);
          }
        },
      ),
    );
  }

  Widget _buildExpenseList(ExpenseState state) {
    final expenses = state.expensesByDate;

    if (expenses.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ExpenseBloc>().add(const LoadExpenses());
      },
      child: Column(
        children: [
          _buildSummaryCard(state),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ExpenseCard(
                    expense: expense,
                    onTap: () => _showExpenseDetails(context, expense),
                    onDelete: () => _deleteExpense(context, expense),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(ExpenseState state) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Expenses',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '\$${state.totalBalance.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${state.expenses.length} expenses',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No expenses yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first expense',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showExpenseDetails(BuildContext context, Expense expense) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildExpenseDetailsSheet(expense),
    );
  }

  Widget _buildExpenseDetailsSheet(Expense expense) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                expense.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Amount', '\$${expense.amount.toStringAsFixed(2)}'),
          _buildDetailRow('Category', expense.category),
          _buildDetailRow('Date', _formatDate(expense.date)),
          if (expense.description != null && expense.description!.isNotEmpty)
            _buildDetailRow('Description', expense.description!),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // TODO: Navigate to edit screen
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteExpense(context, expense);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _deleteExpense(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Expense'),
            content: Text(
              'Are you sure you want to delete "${expense.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<ExpenseBloc>().add(DeleteExpense(expense.id));
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
