import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class LocalStorageService {
  static const String _expensesKey = 'expenses';
  static const String _lastSyncKey = 'last_sync';
  static const String _apiKeyKey = 'notion_api_key';
  static const String _databaseIdKey = 'notion_database_id';

  /// Saves expenses to local storage
  Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = expenses.map((e) => e.toJson()).toList();
    await prefs.setString(_expensesKey, jsonEncode(expensesJson));
  }

  /// Loads expenses from local storage
  Future<List<Expense>> loadExpenses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expensesString = prefs.getString(_expensesKey);
      
      if (expensesString == null) return [];
      
      final expensesJson = jsonDecode(expensesString) as List;
      return expensesJson
          .map((json) => Expense.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If there's an error parsing, return empty list
      return [];
    }
  }

  /// Saves a single expense to local storage
  Future<void> saveExpense(Expense expense) async {
    final expenses = await loadExpenses();
    final existingIndex = expenses.indexWhere((e) => e.id == expense.id);
    
    if (existingIndex >= 0) {
      expenses[existingIndex] = expense;
    } else {
      expenses.add(expense);
    }
    
    await saveExpenses(expenses);
  }

  /// Deletes an expense from local storage
  Future<void> deleteExpense(String expenseId) async {
    final expenses = await loadExpenses();
    expenses.removeWhere((e) => e.id == expenseId);
    await saveExpenses(expenses);
  }

  /// Updates the last sync timestamp
  Future<void> updateLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  /// Gets the last sync timestamp
  Future<DateTime?> getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncString = prefs.getString(_lastSyncKey);
    if (lastSyncString == null) return null;
    return DateTime.parse(lastSyncString);
  }

  /// Saves Notion API credentials
  Future<void> saveApiCredentials({
    required String apiKey,
    required String databaseId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiKeyKey, apiKey);
    await prefs.setString(_databaseIdKey, databaseId);
  }

  /// Gets Notion API credentials
  Future<Map<String, String?>> getApiCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'apiKey': prefs.getString(_apiKeyKey),
      'databaseId': prefs.getString(_databaseIdKey),
    };
  }

  /// Clears all stored data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Checks if data is stale (older than specified duration)
  Future<bool> isDataStale(Duration maxAge) async {
    final lastSync = await getLastSync();
    if (lastSync == null) return true;
    
    final now = DateTime.now();
    return now.difference(lastSync) > maxAge;
  }
} 