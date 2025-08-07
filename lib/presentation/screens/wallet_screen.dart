import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/expense_bloc.dart';
import '../../logic/bloc/expense_event.dart';
import '../../logic/bloc/expense_state.dart';
import '../../logic/bloc/account_bloc.dart';
import '../../logic/bloc/account_event.dart';
import '../../logic/bloc/account_state.dart';
import '../../data/models/account.dart';
import '../widgets/transaction_card.dart';
import 'add_account_screen.dart'; // Changed import
import 'transaction_details_screen.dart';
import 'all_transactions_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String _selectedCurrency = '£';

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(const LoadExpenses());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, accountState) {
        return BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, expenseState) {
            return Scaffold(
              backgroundColor: Colors.grey[50],
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Wallet',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                actions: [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: Colors.black87),
                    onSelected: (value) {
                      switch (value) {
                        case 'add_account':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddAccountScreen(),
                            ),
                          );
                          break;
                        case 'manage_accounts':
                          _showManageAccountsModal(context, accountState);
                          break;
                      }
                    },
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: 'add_account',
                            child: Row(
                              children: [
                                Icon(Icons.add, color: Colors.teal),
                                SizedBox(width: 8),
                                Text('Add Account'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'manage_accounts',
                            child: Row(
                              children: [
                                Icon(Icons.settings, color: Colors.grey),
                                SizedBox(width: 8),
                                Text('Manage Accounts'),
                              ],
                            ),
                          ),
                        ],
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCardsSection(accountState),
                    _buildTransactionsSection(expenseState, accountState),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCardsSection(AccountState accountState) {
    final screenHeight = MediaQuery.of(context).size.height;
    final accounts = accountState.accounts;

    if (accounts.isEmpty) {
      return Container(
        height: screenHeight * 0.3,
        margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_balance_wallet_outlined,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'No accounts yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add your first account to get started',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddAccountScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Account'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: screenHeight * 0.3,
      child: Column(
        children: [
          // Card carousel
          Expanded(
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.85),
              onPageChanged: (index) {
                context.read<AccountBloc>().add(
                  SelectAccount(accounts[index].id),
                );
              },
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                final isSelected = accountState.selectedAccountId == account.id;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.all(
                    isSelected
                        ? MediaQuery.of(context).size.width * 0.02
                        : MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: _buildCard(account, isSelected),
                );
              },
            ),
          ),
          // Card indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                accounts.asMap().entries.map((entry) {
                  final index = entry.key;
                  final isSelected =
                      accountState.selectedAccountId == accounts[index].id;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isSelected ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.teal[600] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Account account, bool isSelected) {
    final cardColor = account.color;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cardColor.shade600, cardColor.shade800],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.3),
            blurRadius: isSelected ? 20 : 10,
            offset: Offset(0, isSelected ? 10 : 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(account.icon, color: Colors.white, size: 32),
                const Spacer(),
                Flexible(
                  child: Text(
                    account.type.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              account.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$_selectedCurrency${account.balance.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              account.number,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsSection(
    ExpenseState expenseState,
    AccountState accountState,
  ) {
    final selectedAccount = accountState.selectedAccount;
    if (selectedAccount == null) {
      return const SizedBox.shrink();
    }
    final filteredTransactions = _getTransactionsForAccount(
      expenseState,
      selectedAccount,
    );

    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${selectedAccount.name} Transactions',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () {
                  _showAllTransactions(context, selectedAccount);
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.teal[600],
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (filteredTransactions.isEmpty)
            _buildEmptyTransactions()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  filteredTransactions.length > 5
                      ? 5
                      : filteredTransactions.length,
              itemBuilder: (context, index) {
                final transaction = filteredTransactions[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap:
                        () =>
                            _navigateToTransactionDetails(context, transaction),
                    child: TransactionCard(
                      expense: transaction,
                      onDelete: () {
                        context.read<ExpenseBloc>().add(
                          DeleteExpense(transaction.id),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactions() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No transactions for this card',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start using this card to see transactions',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  List<dynamic> _getTransactionsForAccount(
    ExpenseState state,
    Account account,
  ) {
    // Filter transactions by account ID
    final transactions =
        state.expenses.where((expense) {
          return expense.accountId == account.id;
        }).toList();

    // If no transactions match the account ID, use mock logic for demo
    if (transactions.isEmpty) {
      return state.expenses.where((expense) {
        // Mock logic: assign transactions to accounts based on amount ranges
        if (account.type == 'wallet') {
          return expense.amount.abs() < 100; // Small transactions go to wallet
        } else if (account.type == 'bank') {
          return expense.amount.abs() >= 100 &&
              expense.amount.abs() < 1000; // Medium transactions to bank
        } else if (account.type == 'investment') {
          return expense.amount.abs() >=
              1000; // Large transactions to investment
        }
        return false;
      }).toList();
    }

    return transactions;
  }

  void _showAllTransactions(BuildContext context, Account account) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllTransactionsScreen()),
    );
  }

  void _showManageAccountsModal(
    BuildContext context,
    AccountState accountState,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Manage Accounts'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: accountState.accounts.length,
                itemBuilder: (context, index) {
                  final account = accountState.accounts[index];
                  return ListTile(
                    leading: Icon(account.icon, color: account.color),
                    title: Text(account.name),
                    subtitle: Text(
                      '${account.type.toUpperCase()} • $_selectedCurrency${account.balance.toStringAsFixed(2)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () {
                            // TODO: Navigate to Edit Account Screen
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmation(context, account);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Account account) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Account'),
            content: Text(
              'Are you sure you want to delete "${account.name}"? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AccountBloc>().add(DeleteAccount(account.id));
                  Navigator.pop(context); // Close delete dialog
                  Navigator.pop(context); // Close manage dialog
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _navigateToTransactionDetails(
    BuildContext context,
    dynamic transaction,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TransactionDetailsScreen(transaction: transaction),
      ),
    );
  }
}
