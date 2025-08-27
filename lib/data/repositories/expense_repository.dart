import '../models/expense.dart';
import '../services/database_helper.dart';
import 'package:uuid/uuid.dart';
import 'account_repository.dart';

class ExpenseRepository {
  final dbHelper = DatabaseHelper();
  final uuid = Uuid();
  final AccountRepository accountRepository;

  ExpenseRepository({required this.accountRepository});

  Future<List<Expense>> getExpenses() async {
    return await dbHelper.getExpenses();
  }

  Future<void> addExpense(Expense expense) async {
    final newExpense = expense.copyWith(
      id: uuid.v4(),
      lastModified: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );
    await dbHelper.insertExpense(newExpense);
    await accountRepository.updateAccountBalance(
      newExpense.accountId,
      newExpense.amount,
    );
  }

  Future<void> updateExpense(Expense expense) async {
    final oldExpense = await dbHelper.getExpenseById(expense.id);
    final updatedExpense = expense.copyWith(
      lastModified: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );
    await dbHelper.updateExpense(updatedExpense);

    // Adjust balance for old and new accounts if the account was changed
    if (oldExpense.accountId != updatedExpense.accountId) {
      await accountRepository.updateAccountBalance(
        oldExpense.accountId,
        -oldExpense.amount, // Revert old transaction
      );
      await accountRepository.updateAccountBalance(
        updatedExpense.accountId,
        updatedExpense.amount, // Apply new transaction
      );
    } else {
      final difference = updatedExpense.amount - oldExpense.amount;
      await accountRepository.updateAccountBalance(
        updatedExpense.accountId,
        difference,
      );
    }
  }

  Future<void> deleteExpense(String id) async {
    final expense = await dbHelper.getExpenseById(id);
    final deletedExpense = expense.copyWith(
      isDeleted: true,
      lastModified: DateTime.now(),
      syncStatus: SyncStatus.pending,
    );
    await dbHelper.updateExpense(deletedExpense);
    await accountRepository.updateAccountBalance(
      expense.accountId,
      -expense.amount, // Revert the transaction amount
    );
  }
}
