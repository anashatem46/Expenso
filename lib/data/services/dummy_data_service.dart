import '../models/expense.dart';

class DummyDataService {
  static List<Expense> getDummyExpenses() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      Expense(
        id: '1',
        title: 'Coffee at Starbucks',
        amount: -5.50,
        category: 'Coffee',
        date: today.subtract(const Duration(days: 0)),
        description: 'Morning coffee',
        currency: '£',
        accountId: 'wallet_1',
      ),
      Expense(
        id: '2',
        title: 'Lunch at Chipotle',
        amount: -12.75,
        category: 'Food',
        date: today.subtract(const Duration(days: 1)),
        description: 'Burrito bowl',
        currency: '£',
        accountId: 'wallet_1',
      ),
      Expense(
        id: '3',
        title: 'Uber to work',
        amount: -8.25,
        category: 'Transport',
        date: today.subtract(const Duration(days: 2)),
        description: 'Morning commute',
        currency: '£',
        accountId: 'bank_1',
      ),
      Expense(
        id: '4',
        title: 'Salary',
        amount: 2500.00,
        category: 'Salary',
        date: today.subtract(const Duration(days: 3)),
        description: 'Monthly salary',
        currency: '£',
        accountId: 'bank_1',
      ),
      Expense(
        id: '5',
        title: 'Movie tickets',
        amount: -24.00,
        category: 'Entertainment',
        date: today.subtract(const Duration(days: 4)),
        description: 'Avengers movie',
        currency: '£',
        accountId: 'wallet_1',
      ),
      Expense(
        id: '6',
        title: 'Groceries',
        amount: -45.30,
        category: 'Food',
        date: today.subtract(const Duration(days: 5)),
        description: 'Weekly groceries',
      ),
      Expense(
        id: '7',
        title: 'Amazon purchase',
        amount: -89.99,
        category: 'Shopping',
        date: today.subtract(const Duration(days: 6)),
        description: 'New headphones',
      ),
      Expense(
        id: '8',
        title: 'Dental checkup',
        amount: -120.00,
        category: 'Health',
        date: today.subtract(const Duration(days: 7)),
        description: 'Regular checkup',
      ),
      Expense(
        id: '9',
        title: 'Online course',
        amount: -199.00,
        category: 'Education',
        date: today.subtract(const Duration(days: 8)),
        description: 'Flutter development course',
      ),
      Expense(
        id: '10',
        title: 'Freelance project',
        amount: 500.00,
        category: 'Salary',
        date: today.subtract(const Duration(days: 9)),
        description: 'Web development project',
      ),
      Expense(
        id: '11',
        title: 'Dinner with friends',
        amount: -35.50,
        category: 'Food',
        date: today.subtract(const Duration(days: 10)),
        description: 'Italian restaurant',
      ),
      Expense(
        id: '12',
        title: 'Gas station',
        amount: -45.00,
        category: 'Transport',
        date: today.subtract(const Duration(days: 11)),
        description: 'Fuel for car',
      ),
    ];
  }
}
