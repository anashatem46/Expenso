import '../models/account.dart';
import '../models/expense.dart'; // For SyncStatus
import '../services/database_helper.dart';
import 'package:uuid/uuid.dart';

class AccountRepository {
  final dbHelper = DatabaseHelper();
  final uuid = Uuid();

  Future<List<Account>> getAccounts() async {
    return await dbHelper.getAccounts();
  }

  Future<Account> getAccountById(String id) async {
    return await dbHelper.getAccountById(id);
  }

  Future<void> addAccount(Account account) async {
    final newAccount = account.copyWith(
      id: uuid.v4(),
      lastModified: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );
    await dbHelper.insertAccount(newAccount);
  }

  Future<void> updateAccount(Account account) async {
    final updatedAccount = account.copyWith(
      lastModified: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );
    await dbHelper.updateAccount(updatedAccount);
  }

  Future<void> deleteAccount(String id) async {
    final account = await dbHelper.getAccountById(id);
    final deletedAccount = account.copyWith(
      isDeleted: true,
      lastModified: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );
    await dbHelper.updateAccount(deletedAccount);
  }

  Future<void> updateAccountBalance(String accountId, double amount) async {
    final account = await dbHelper.getAccountById(accountId);
    final updatedAccount = account.copyWith(
      balance: account.balance + amount,
      lastModified: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );
    await dbHelper.updateAccount(updatedAccount);
  }
}
