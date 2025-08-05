import 'package:json_annotation/json_annotation.dart';

part 'expense.g.dart';

@JsonSerializable()
class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? description;
  final String? notionId;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
    this.notionId,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? description,
    String? notionId,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
      notionId: notionId ?? this.notionId,
    );
  }

  @override
  String toString() {
    return 'Expense(id: $id, title: $title, amount: $amount, category: $category, date: $date, description: $description, notionId: $notionId)';
  }
} 