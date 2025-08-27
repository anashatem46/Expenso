import 'package:json_annotation/json_annotation.dart';

part 'expense.g.dart';

enum SyncStatus { synced, pending, failed }

@JsonSerializable()
class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? description;
  final String currency;
  final String accountId;

  // New fields for synchronization
  final DateTime lastModified;
  final bool isDeleted;
  final SyncStatus syncStatus;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    this.currency = '£',
    this.accountId = 'default',
    required this.lastModified,
    this.isDeleted = false,
    this.syncStatus = SyncStatus.pending,
  });

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  // For SQLite
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      description: map['description'],
      currency: map['currency'],
      accountId: map['accountId'],
      lastModified: DateTime.parse(map['lastModified']),
      isDeleted: map['isDeleted'] == 1,
      syncStatus: SyncStatus.values[map['syncStatus']],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'description': description,
      'currency': currency,
      'accountId': accountId,
      'lastModified': lastModified.toIso8601String(),
      'isDeleted': isDeleted ? 1 : 0,
      'syncStatus': syncStatus.index,
    };
  }

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? description,
    String? currency,
    String? accountId,
    DateTime? lastModified,
    bool? isDeleted,
    SyncStatus? syncStatus,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      currency: currency ?? this.currency,
      accountId: accountId ?? this.accountId,
      lastModified: lastModified ?? this.lastModified,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  String toString() {
    return 'Expense(id: $id, title: $title, amount: $amount, category: $category, date: $date, description: $description, currency: $currency, accountId: $accountId, lastModified: $lastModified, isDeleted: $isDeleted, syncStatus: $syncStatus)';
  }
}
