import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../logic/bloc/expense_bloc.dart';
import '../../logic/bloc/expense_event.dart';
import '../../logic/bloc/expense_state.dart';
import '../widgets/transaction_card.dart';
import '../widgets/month_selector.dart';
import '../widgets/spending_chart.dart';
import '../widgets/add_transaction_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(const LoadExpenses());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildBalanceSection(state),
                _buildChartSection(state),
                _buildMonthSelector(state),
                Expanded(child: _buildTransactionList(state)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Anas Hatem ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('EEEE, d MMMM').format(DateTime.now()),
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              // TODO: Navigate to analytics/settings
            },
            icon: Icon(
              Icons.analytics_outlined,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(ExpenseState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Current Balance',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${state.totalBalance.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color:
                  state.totalBalance >= 0 ? Colors.green[600] : Colors.red[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(ExpenseState state) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Spending Trend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(height: 120, child: SpendingChart(data: state.chartData)),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(ExpenseState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: MonthSelector(
        selectedMonth: state.selectedMonth,
        onMonthSelected: (month) {
          context.read<ExpenseBloc>().add(SelectMonth(month));
        },
      ),
    );
  }

  Widget _buildTransactionList(ExpenseState state) {
    if (state.status == ExpenseStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == ExpenseStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              state.errorMessage ?? 'An error occurred',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ExpenseBloc>().add(const LoadExpenses());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final transactions = state.expensesForSelectedMonth;

    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions this month',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first transaction',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TransactionCard(
            expense: transaction,
            onDelete: () {
              context.read<ExpenseBloc>().add(DeleteExpense(transaction.id));
            },
          ),
        );
      },
    );
  }
}
