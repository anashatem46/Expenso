import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/account.dart';
import '../../data/services/account_service.dart';
import '../../logic/bloc/account_bloc.dart';
import '../../logic/bloc/account_event.dart';

class AddAccountModal extends StatefulWidget {
  const AddAccountModal({Key? key}) : super(key: key);

  @override
  State<AddAccountModal> createState() => _AddAccountModalState();
}

class _AddAccountModalState extends State<AddAccountModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _numberController = TextEditingController();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final availableHeight = screenHeight - keyboardHeight;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: availableHeight * 0.9,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAccountTypeSelector(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      _buildNameField(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      _buildBalanceField(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      _buildNumberField(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      _buildIconSelector(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      _buildColorSelector(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      _buildSubmitButton(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Add Account',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTypeSelector() {
    final typeOptions = AccountService.getAccountTypeOptions();

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
                  onTap: () => setState(() => _selectedType = option['type']),
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
                          option['icon'],
                          color:
                              isSelected ? Colors.teal[600] : Colors.grey[600],
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          option['name'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color:
                                isSelected
                                    ? Colors.teal[600]
                                    : Colors.grey[600],
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
          keyboardType: TextInputType.number,
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
          decoration: InputDecoration(
            hintText: 'Enter account number or identifier',
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
              return 'Please enter account number or identifier';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Icon',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _availableIcons.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedIconIndex == index;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIconIndex = index),
                  child: Container(
                    width: 60,
                    height: 60,
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
                      _availableIcons[index],
                      color: isSelected ? Colors.teal[600] : Colors.grey[600],
                      size: 24,
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
          'Choose Color',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _availableColors.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedColorIndex == index;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedColorIndex = index),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _availableColors[index][100],
                      border: Border.all(
                        color: isSelected ? Colors.black87 : Colors.grey[300]!,
                        width: isSelected ? 3 : 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        isSelected
                            ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 24,
                            )
                            : null,
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
      height: 50,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal[600],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Add Account',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final account = Account(
        id: AccountService.generateAccountId(_selectedType),
        name: _nameController.text,
        type: _selectedType,
        balance: double.tryParse(_balanceController.text) ?? 0.0,
        number: _numberController.text,
        iconCodePoint: _availableIcons[_selectedIconIndex].codePoint,
        colorValue: _availableColors[_selectedColorIndex].value,
      );

      context.read<AccountBloc>().add(AddAccount(account));
      Navigator.pop(context);
    }
  }
}
