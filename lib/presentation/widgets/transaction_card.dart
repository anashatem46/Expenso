import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/expense.dart';

class TransactionCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onDelete;

  const TransactionCard({
    super.key,
    required this.expense,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildCategoryIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTransactionDate(expense.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${expense.amount >= 0 ? '+' : ''}\$${expense.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: expense.amount >= 0 ? Colors.green[600] : Colors.red[600],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 16),
                  onPressed: onDelete,
                  color: Colors.red[400],
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon() {
    String emoji;
    Color backgroundColor;

    switch (expense.category.toLowerCase()) {
      case 'food':
        emoji = '🍔';
        backgroundColor = Colors.orange[100]!;
        break;
      case 'coffee':
        emoji = '☕';
        backgroundColor = Colors.brown[100]!;
        break;
      case 'transport':
        emoji = '🚗';
        backgroundColor = Colors.blue[100]!;
        break;
      case 'shopping':
        emoji = '🛍️';
        backgroundColor = Colors.purple[100]!;
        break;
      case 'entertainment':
        emoji = '🎬';
        backgroundColor = Colors.pink[100]!;
        break;
      case 'health':
        emoji = '🏥';
        backgroundColor = Colors.red[100]!;
        break;
      case 'education':
        emoji = '📚';
        backgroundColor = Colors.indigo[100]!;
        break;
      case 'salary':
        emoji = '💰';
        backgroundColor = Colors.green[100]!;
        break;
      default:
        emoji = '📝';
        backgroundColor = Colors.grey[100]!;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  String _formatTransactionDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate == today) {
      return 'Today — ${expense.category}';
    } else if (transactionDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday — ${expense.category}';
    } else {
      return '${DateFormat('EEEE, d MMMM yyyy').format(date)} — ${expense.category}';
    }
  }
} 