import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';
import '../models/account.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'expenso.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE accounts(
        id TEXT PRIMARY KEY,
        name TEXT,
        type TEXT,
        balance REAL,
        number TEXT,
        iconCodePoint INTEGER,
        colorValue INTEGER,
        lastModified TEXT,
        isDeleted INTEGER,
        syncStatus INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE expenses(
        id TEXT PRIMARY KEY,
        title TEXT,
        amount REAL,
        category TEXT,
        date TEXT,
        description TEXT,
        currency TEXT,
        accountId TEXT,
        lastModified TEXT,
        isDeleted INTEGER,
        syncStatus INTEGER,
        FOREIGN KEY (accountId) REFERENCES accounts(id)
      )
    ''');
  }

  // Account methods
  Future<void> insertAccount(Account account) async {
    final db = await database;
    await db.insert(
      'accounts',
      account.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Account>> getAccounts() async {
    final db = await database;
    final maps = await db.query(
      'accounts',
      where: 'isDeleted = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) {
      return Account.fromMap(maps[i]);
    });
  }

  Future<Account> getAccountById(String id) async {
    final db = await database;
    final maps = await db.query('accounts', where: 'id = ?', whereArgs: [id]);
    return Account.fromMap(maps.first);
  }

  Future<void> updateAccount(Account account) async {
    final db = await database;
    await db.update(
      'accounts',
      account.toMap(),
      where: 'id = ?',
      whereArgs: [account.id],
    );
  }

  // Expense methods
  Future<void> insertExpense(Expense expense) async {
    final db = await database;
    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final maps = await db.query(
      'expenses',
      where: 'isDeleted = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) {
      return Expense.fromMap(maps[i]);
    });
  }

  Future<Expense> getExpenseById(String id) async {
    final db = await database;
    final maps = await db.query('expenses', where: 'id = ?', whereArgs: [id]);
    return Expense.fromMap(maps.first);
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await database;
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // Methods for synchronization
  Future<List<Account>> getPendingAccounts() async {
    final db = await database;
    final maps = await db.query(
      'accounts',
      where: 'syncStatus != ?',
      whereArgs: [SyncStatus.synced.index],
    );
    return List.generate(maps.length, (i) => Account.fromMap(maps[i]));
  }

  Future<List<Expense>> getPendingExpenses() async {
    final db = await database;
    final maps = await db.query(
      'expenses',
      where: 'syncStatus != ?',
      whereArgs: [SyncStatus.synced.index],
    );
    return List.generate(maps.length, (i) => Expense.fromMap(maps[i]));
  }
}
