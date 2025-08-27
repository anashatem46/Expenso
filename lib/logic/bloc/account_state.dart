import 'package:equatable/equatable.dart';
import '../../data/models/account.dart';

enum AccountStatus { initial, loading, success, failure }

class AccountState extends Equatable {
  final AccountStatus status;
  final List<Account> accounts;
  final String? selectedAccountId;
  final String? errorMessage;
  final double totalBalance;

  const AccountState({
    this.status = AccountStatus.initial,
    this.accounts = const [],
    this.selectedAccountId,
    this.errorMessage,
    this.totalBalance = 0.0,
  });

  AccountState copyWith({
    AccountStatus? status,
    List<Account>? accounts,
    String? selectedAccountId,
    String? errorMessage,
    double? totalBalance,
  }) {
    return AccountState(
      status: status ?? this.status,
      accounts: accounts ?? this.accounts,
      selectedAccountId: selectedAccountId ?? this.selectedAccountId,
      errorMessage: errorMessage ?? this.errorMessage,
      totalBalance: totalBalance ?? this.totalBalance,
    );
  }

  // Helper getters
  Account? get selectedAccount {
    if (selectedAccountId == null) return null;
    try {
      return accounts.firstWhere((account) => account.id == selectedAccountId);
    } catch (e) {
      return null;
    }
  }

  List<Account> get walletAccounts {
    return accounts.where((account) => account.type == 'wallet').toList();
  }

  List<Account> get bankAccounts {
    return accounts.where((account) => account.type == 'bank').toList();
  }

  List<Account> get investmentAccounts {
    return accounts.where((account) => account.type == 'investment').toList();
  }

  @override
  List<Object?> get props => [
    status,
    accounts,
    selectedAccountId,
    errorMessage,
    totalBalance,
  ];
}
