import 'package:flutter/foundation.dart';
import '../../data/models/expense.dart';
import '../../data/api/notion_api_service.dart';
import '../../data/storage/local_storage_service.dart';

enum ExpenseState { initial, loading, loaded, error }

class ExpenseProvider with ChangeNotifier {
  final NotionApiService _apiService;
  final LocalStorageService _storageService;

  ExpenseProvider({
    required NotionApiService apiService,
    required LocalStorageService storageService,
  })  : _apiService = apiService,
        _storageService = storageService;

  // State
  ExpenseState _state = ExpenseState.initial;
  List<Expense> _expenses = [];
  String? _errorMessage;
  bool _isRefreshing = false;

  // Getters
  ExpenseState get state => _state;
  List<Expense> get expenses => _expenses;
  String? get errorMessage => _errorMessage;
  bool get isRefreshing => _isRefreshing;
  bool get isLoading => _state == ExpenseState.loading;

  // Computed properties
  double get totalAmount => _expenses.fold(0, (sum, expense) => sum + expense.amount);
  
  List<Expense> get expensesByDate {
    final sorted = List<Expense>.from(_expenses);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  Map<String, double> get expensesByCategory {
    final Map<String, double> categoryTotals = {};
    for (final expense in _expenses) {
      categoryTotals[expense.category] = 
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }
    return categoryTotals;
  }

  /// Loads expenses from local storage and optionally syncs with API
  Future<void> loadExpenses({bool syncWithApi = false}) async {
    try {
      _setState(ExpenseState.loading);
      
      // Load from local storage first
      final localExpenses = await _storageService.loadExpenses();
      _expenses = localExpenses;
      _setState(ExpenseState.loaded);

      // Sync with API if requested
      if (syncWithApi) {
        await _syncWithApi();
      }
    } catch (e) {
      _setError('Failed to load expenses: $e');
    }
  }

  /// Refreshes expenses from API
  Future<void> refreshExpenses() async {
    if (_isRefreshing) return;
    
    try {
      _isRefreshing = true;
      notifyListeners();
      
      await _syncWithApi();
    } catch (e) {
      _setError('Failed to refresh expenses: $e');
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Adds a new expense
  Future<void> addExpense(Expense expense) async {
    try {
      _setState(ExpenseState.loading);
      
      // Add to API first
      final createdExpense = await _apiService.createExpense(expense);
      
      // Add to local list
      _expenses.add(createdExpense);
      
      // Save to local storage
      await _storageService.saveExpense(createdExpense);
      await _storageService.updateLastSync();
      
      _setState(ExpenseState.loaded);
    } catch (e) {
      _setError('Failed to add expense: $e');
    }
  }

  /// Updates an existing expense
  Future<void> updateExpense(Expense expense) async {
    try {
      _setState(ExpenseState.loading);
      
      // Update in API
      await _apiService.updateExpense(expense);
      
      // Update in local list
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = expense;
      }
      
      // Save to local storage
      await _storageService.saveExpense(expense);
      await _storageService.updateLastSync();
      
      _setState(ExpenseState.loaded);
    } catch (e) {
      _setError('Failed to update expense: $e');
    }
  }

  /// Deletes an expense
  Future<void> deleteExpense(String expenseId) async {
    try {
      _setState(ExpenseState.loading);
      
      final expense = _expenses.firstWhere((e) => e.id == expenseId);
      
      // Delete from API if it has a Notion ID
      if (expense.notionId != null) {
        await _apiService.deleteExpense(expense.notionId!);
      }
      
      // Remove from local list
      _expenses.removeWhere((e) => e.id == expenseId);
      
      // Delete from local storage
      await _storageService.deleteExpense(expenseId);
      await _storageService.updateLastSync();
      
      _setState(ExpenseState.loaded);
    } catch (e) {
      _setError('Failed to delete expense: $e');
    }
  }

  /// Syncs local data with API
  Future<void> _syncWithApi() async {
    try {
      final apiExpenses = await _apiService.fetchExpenses();
      
      // Merge API data with local data
      final mergedExpenses = <Expense>[];
      final localExpenseMap = <String, Expense>{};
      
      for (final expense in _expenses) {
        localExpenseMap[expense.notionId ?? expense.id] = expense;
      }
      
      for (final apiExpense in apiExpenses) {
        final localExpense = localExpenseMap[apiExpense.notionId];
        if (localExpense != null) {
          // Use local expense if it exists, but update with API data
          mergedExpenses.add(apiExpense);
        } else {
          // New expense from API
          mergedExpenses.add(apiExpense);
        }
      }
      
      // Add local expenses that don't exist in API
      for (final localExpense in _expenses) {
        if (localExpense.notionId == null) {
          mergedExpenses.add(localExpense);
        }
      }
      
      _expenses = mergedExpenses;
      await _storageService.saveExpenses(_expenses);
      await _storageService.updateLastSync();
      
      _setState(ExpenseState.loaded);
    } catch (e) {
      // If API sync fails, keep local data
      _setState(ExpenseState.loaded);
    }
  }

  /// Clears error state
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Sets the current state
  void _setState(ExpenseState state) {
    _state = state;
    _errorMessage = null;
    notifyListeners();
  }

  /// Sets error state
  void _setError(String message) {
    _state = ExpenseState.error;
    _errorMessage = message;
    notifyListeners();
  }
} 