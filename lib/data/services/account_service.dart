import 'package:flutter/material.dart';
import '../models/account.dart';

class AccountService {
  static List<Account> _accounts = [
    Account(
      id: 'wallet_1',
      name: 'Personal Wallet',
      type: 'wallet',
      balance: 1250.00,
      number: '•••• ••••',
      iconCodePoint: Icons.account_balance_wallet.codePoint,
      colorValue: Colors.orange.value,
    ),
    Account(
      id: 'bank_1',
      name: 'Chase Bank',
      type: 'bank',
      balance: 5420.00,
      number: '•••• 1234',
      iconCodePoint: Icons.credit_card.codePoint,
      colorValue: Colors.blue.value,
    ),
    Account(
      id: 'investment_1',
      name: 'Investment Account',
      type: 'investment',
      balance: 12500.00,
      number: '•••• 5678',
      iconCodePoint: Icons.trending_up.codePoint,
      colorValue: Colors.green.value,
    ),
  ];

  static List<Account> getAllAccounts() {
    return List.unmodifiable(_accounts);
  }

  static Account? getAccountById(String id) {
    try {
      return _accounts.firstWhere((account) => account.id == id);
    } catch (e) {
      return null;
    }
  }

  static void addAccount(Account account) {
    _accounts.add(account);
  }

  static void updateAccount(Account updatedAccount) {
    final index = _accounts.indexWhere(
      (account) => account.id == updatedAccount.id,
    );
    if (index != -1) {
      _accounts[index] = updatedAccount;
    }
  }

  static void removeAccount(String accountId) {
    _accounts.removeWhere((account) => account.id == accountId);
  }

  static void updateAccountBalance(String accountId, double amount) {
    final index = _accounts.indexWhere((account) => account.id == accountId);
    if (index != -1) {
      final account = _accounts[index];
      _accounts[index] = account.copyWith(balance: account.balance + amount);
    }
  }

  static List<String> getAccountTypes() {
    return ['wallet', 'bank', 'investment'];
  }

  static List<Map<String, dynamic>> getAccountTypeOptions() {
    return [
      {
        'type': 'wallet',
        'name': 'Wallet',
        'icon': Icons.account_balance_wallet,
        'color': Colors.orange,
      },
      {
        'type': 'bank',
        'name': 'Bank Account',
        'icon': Icons.credit_card,
        'color': Colors.blue,
      },
      {
        'type': 'investment',
        'name': 'Investment',
        'icon': Icons.trending_up,
        'color': Colors.green,
      },
    ];
  }

  static String generateAccountId(String type) {
    final existingIds =
        _accounts
            .where((account) => account.type == type)
            .map((account) => account.id)
            .toList();

    int counter = 1;
    String newId;
    do {
      newId = '${type}_$counter';
      counter++;
    } while (existingIds.contains(newId));

    return newId;
  }
}
