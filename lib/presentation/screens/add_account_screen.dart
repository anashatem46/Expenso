import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/account.dart';
import '../../logic/bloc/account_bloc.dart';
import '../../logic/bloc/account_event.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({Key? key}) : super(key: key);

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _numberController = TextEditingController();
  final _uuid = Uuid();

  final _nameFocusNode = FocusNode();
  final _balanceFocusNode = FocusNode();
  final _numberFocusNode = FocusNode();

  String _selectedType = 'wallet';
  int _selectedIconIndex = 0;
  int _selectedColorIndex = 0;

  final List<IconData> _availableIcons = [
    Icons.account_balance_wallet,
    Icons.credit_card,
    Icons.trending_up,
    Icons.savings,
    Icons.account_balance,
    Icons.payment,
    Icons.monetization_on,
    Icons.business_center,
  ];
  final List<MaterialColor> _availableColors = [
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _numberController.dispose();
    _nameFocusNode.dispose();
    _balanceFocusNode.dispose();
    _numberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Account')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAccountTypeSelector(),
                const SizedBox(height: 20),
                _buildNameField(),
                const SizedBox(height: 20),
                _buildBalanceField(),
                const SizedBox(height: 20),
                _buildNumberField(),
                const SizedBox(height: 20),
                _buildIconSelector(),
                const SizedBox(height: 20),
                _buildColorSelector(),
                const SizedBox(height: 30),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTypeSelector() {
    final typeOptions = [
      {
        'type': 'wallet',
        'name': 'Wallet',
        'icon': Icons.account_balance_wallet,
      },
      {'type': 'bank', 'name': 'Bank Account', 'icon': Icons.credit_card},
      {'type': 'investment', 'name': 'Investment', 'icon': Icons.trending_up},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Type',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: typeOptions.length,
            itemBuilder: (context, index) {
              final option = typeOptions[index];
              final isSelected = _selectedType == option['type'];

              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap:
                      () => setState(
                        () => _selectedType = option['type'] as String,
                      ),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal[50] : Colors.grey[50],
                      border: Border.all(
                        color:
                            isSelected ? Colors.teal[400]! : Colors.grey[300]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          option['icon'] as IconData,
                          color:
                              isSelected ? Colors.teal[600] : Colors.grey[600],
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          option['name'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color:
                                isSelected
                                    ? Colors.teal[700]
                                    : Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Name',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          focusNode: _nameFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            _balanceFocusNode.requestFocus();
          },
          decoration: InputDecoration(
            hintText: 'Enter account name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.teal[400]!),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter an account name';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBalanceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Initial Balance',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _balanceController,
          focusNode: _balanceFocusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            _numberFocusNode.requestFocus();
          },
          decoration: InputDecoration(
            hintText: '0.00',
            prefixText: '£ ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.teal[400]!),
            ),
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter initial balance';
            }
            if (double.tryParse(value!) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Number/Identifier',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _numberController,
          focusNode: _numberFocusNode,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            hintText: 'e.g., •••• 1234',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.teal[400]!),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Icon',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _availableIcons.length,
            itemBuilder: (context, index) {
              final icon = _availableIcons[index];
              final isSelected = _selectedIconIndex == index;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIconIndex = index),
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal[50] : Colors.grey[50],
                      border: Border.all(
                        color:
                            isSelected ? Colors.teal[400]! : Colors.grey[300]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.teal[600] : Colors.grey[600],
                      size: 28,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Color',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _availableColors.length,
            itemBuilder: (context, index) {
              final color = _availableColors[index];
              final isSelected = _selectedColorIndex == index;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedColorIndex = index),
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color: color.shade100,
                      border: Border.all(
                        color:
                            isSelected ? Colors.teal[400]! : Colors.grey[300]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child:
                          isSelected
                              ? Icon(
                                Icons.check,
                                color: color.shade800,
                                size: 28,
                              )
                              : Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final newAccount = Account(
              id: _uuid.v4(),
              name: _nameController.text,
              type: _selectedType,
              balance: double.parse(_balanceController.text),
              number: _numberController.text,
              iconCodePoint: _availableIcons[_selectedIconIndex].codePoint,
              colorValue: _availableColors[_selectedColorIndex].value,
              lastModified: DateTime.now(),
            );

            context.read<AccountBloc>().add(AddAccount(newAccount));
            Navigator.pop(context);
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.teal[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Add Account',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
