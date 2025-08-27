import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/expense.dart';
import '../../logic/bloc/expense_bloc.dart';
import '../../logic/bloc/expense_event.dart';
import '../widgets/transaction_card.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final Expense transaction;

  const TransactionDetailsScreen({Key? key, required this.transaction})
    : super(key: key);

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  bool _isEditing = false;
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late String _selectedCategory;
  late DateTime _selectedDate;
  late String _selectedCurrency;

  final List<String> _categories = [
    'Food',
    'Coffee',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Health',
    'Travel',
    'Education',
    'Investment',
    'Income',
    'Salary',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.transaction.title);
    _amountController = TextEditingController(
      text: widget.transaction.amount.abs().toString(),
    );
    _descriptionController = TextEditingController(
      text: widget.transaction.description ?? '',
    );
    _selectedCategory =
        _categories.contains(widget.transaction.category)
            ? widget.transaction.category
            : _categories.first;
    _selectedDate = widget.transaction.date;
    _selectedCurrency = '£';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: Text(
          _isEditing ? 'Edit Transaction' : 'Transaction Details',
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              onPressed: () => setState(() => _isEditing = true),
              icon: const Icon(Icons.edit, color: Colors.black87),
            ),
          if (_isEditing)
            TextButton(
              onPressed: _saveTransaction,
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.teal[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (_isEditing)
            IconButton(
              onPressed: () => setState(() => _isEditing = false),
              icon: const Icon(Icons.close, color: Colors.black87),
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteDialog();
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Transaction Preview Card
            if (!_isEditing) ...[
              Container(
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.03,
                ),
                child: TransactionCard(expense: widget.transaction),
              ),
            ],

            // Transaction Details
            _buildDetailSection('Transaction Details', [
              _buildDetailRow(
                'Title',
                _isEditing
                    ? _buildTextField(_titleController, 'Transaction title')
                    : Text(
                      widget.transaction.title,
                      style: const TextStyle(fontSize: 16),
                    ),
              ),
              _buildDetailRow(
                'Amount',
                _isEditing
                    ? Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '£',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTextField(
                            _amountController,
                            'Amount',
                            isNumber: true,
                          ),
                        ),
                      ],
                    )
                    : Text(
                      '${widget.transaction.currency}${widget.transaction.amount.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            widget.transaction.amount >= 0
                                ? Colors.green
                                : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
              _buildDetailRow(
                'Category',
                _isEditing
                    ? DropdownButton<String>(
                      value: _selectedCategory,
                      onChanged:
                          (value) => setState(() => _selectedCategory = value!),
                      items:
                          _categories
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ),
                              )
                              .toList(),
                    )
                    : Text(
                      widget.transaction.category,
                      style: const TextStyle(fontSize: 16),
                    ),
              ),
              _buildDetailRow(
                'Date',
                _isEditing
                    ? GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                    : Text(
                      '${widget.transaction.date.day}/${widget.transaction.date.month}/${widget.transaction.date.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
              ),
              if (widget.transaction.description != null || _isEditing)
                _buildDetailRow(
                  'Description',
                  _isEditing
                      ? _buildTextField(
                        _descriptionController,
                        'Description (optional)',
                        maxLines: 3,
                      )
                      : Text(
                        widget.transaction.description ?? 'No description',
                        style: const TextStyle(fontSize: 16),
                      ),
                ),
            ]),

            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

            // Account Information
            _buildDetailSection('Account Information', [
              _buildDetailRow(
                'Account ID',
                Text(
                  widget.transaction.accountId,
                  style: const TextStyle(fontSize: 16, fontFamily: 'monospace'),
                ),
              ),
              _buildDetailRow(
                'Transaction ID',
                Text(
                  widget.transaction.id,
                  style: const TextStyle(fontSize: 16, fontFamily: 'monospace'),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height * 0.02,
      ),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, Widget value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: value),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.teal[600]!),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _saveTransaction() {
    final double amount = double.tryParse(_amountController.text) ?? 0;
    final bool isExpense = widget.transaction.amount < 0;

    final updatedTransaction = widget.transaction.copyWith(
      title: _titleController.text,
      amount: isExpense ? -amount : amount,
      category: _selectedCategory,
      date: _selectedDate,
      description:
          _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
      currency: _selectedCurrency,
    );

    context.read<ExpenseBloc>().add(UpdateExpense(updatedTransaction));
    Navigator.pop(context);
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Transaction'),
            content: const Text(
              'Are you sure you want to delete this transaction? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.read<ExpenseBloc>().add(
                    DeleteExpense(widget.transaction.id),
                  );
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close details screen
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
