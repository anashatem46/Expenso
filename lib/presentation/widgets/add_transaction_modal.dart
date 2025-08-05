import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../logic/bloc/expense_bloc.dart';
import '../../logic/bloc/expense_event.dart';
import '../../logic/bloc/expense_state.dart';
import '../../data/models/expense.dart';

class AddTransactionModal extends StatefulWidget {
  const AddTransactionModal({super.key});

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();

  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _isIncome = false; // New toggle for income/expense

  final List<String> _expenseCategories = [
    'Food',
    'Coffee',
    'Transport',
    'Shopping',
    'Entertainment',
    'Health',
    'Education',
    'Other',
  ];

  final List<String> _incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Bonus',
    'Other',
  ];

  List<String> get _categories =>
      _isIncome ? _incomeCategories : _expenseCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories.first;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildTransactionTypeToggle(),
            _buildDateSelector(),
            const SizedBox(height: 16),
            _buildAmountField(),
            _buildCategoryAndReason(),
            _buildSubmitButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Add Transaction',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTypeToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isIncome = false;
                  _selectedCategory = _categories.first;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isIncome ? Colors.red[100] : Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  border: Border.all(
                    color: !_isIncome ? Colors.red[600]! : Colors.grey[300]!,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_circle_outline,
                        color: !_isIncome ? Colors.red[600] : Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Expense',
                        style: TextStyle(
                          color:
                              !_isIncome ? Colors.red[600] : Colors.grey[600],
                          fontWeight:
                              !_isIncome ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isIncome = true;
                  _selectedCategory = _categories.first;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isIncome ? Colors.green[100] : Colors.grey[100],
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  border: Border.all(
                    color: _isIncome ? Colors.green[600]! : Colors.grey[300]!,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: _isIncome ? Colors.green[600] : Colors.grey[600],
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Income',
                        style: TextStyle(
                          color:
                              _isIncome ? Colors.green[600] : Colors.grey[600],
                          fontWeight:
                              _isIncome ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          final date = DateTime.now().subtract(Duration(days: 5 - index));
          final isSelected = date.day == _selectedDate.day;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDate = date;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green[600] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('E').format(date),
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.grey[600],
                      ),
                    ),
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAmountField() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: TextFormField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: 'Amount',
          prefixText: '\$',
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _isIncome ? Colors.green[600]! : Colors.red[600]!,
              width: 2,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter an amount';
          }
          final amount = double.tryParse(value);
          if (amount == null || amount == 0) {
            return 'Please enter a valid amount';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCategoryAndReason() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _buildCategorySelector(),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Enter your reason',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a reason';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return PopupMenuButton<String>(
      initialValue: _selectedCategory,
      onSelected: (String value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_getCategoryEmoji(_selectedCategory)),
            const SizedBox(width: 8),
            Text(_selectedCategory, style: const TextStyle(fontSize: 16)),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      itemBuilder:
          (context) =>
              _categories.map((category) {
                return PopupMenuItem<String>(
                  value: category,
                  child: Row(
                    children: [
                      Text(_getCategoryEmoji(category)),
                      const SizedBox(width: 8),
                      Text(category),
                    ],
                  ),
                );
              }).toList(),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      margin: const EdgeInsets.all(20),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isIncome ? Colors.green[600] : Colors.red[600],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            _isLoading
                ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                : Text(
                  'Add ${_isIncome ? 'Income' : 'Expense'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }

  String _getCategoryEmoji(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return '🍔';
      case 'coffee':
        return '☕';
      case 'transport':
        return '🚗';
      case 'shopping':
        return '🛍️';
      case 'entertainment':
        return '🎬';
      case 'health':
        return '🏥';
      case 'education':
        return '📚';
      case 'salary':
        return '💰';
      case 'freelance':
        return '💼';
      case 'investment':
        return '📈';
      case 'bonus':
        return '🎁';
      default:
        return '📝';
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final amount = double.parse(_amountController.text);
      final expense = Expense(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _reasonController.text.trim(),
        amount:
            _isIncome
                ? amount
                : -amount, // Negative for expenses, positive for income
        category: _selectedCategory,
        date: _selectedDate,
        description: null,
      );

      context.read<ExpenseBloc>().add(AddExpense(expense));

      // Close the modal after successful submission
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add transaction: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
