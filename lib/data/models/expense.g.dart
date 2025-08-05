// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
  id: json['id'] as String,
  title: json['title'] as String,
  amount: (json['amount'] as num).toDouble(),
  category: json['category'] as String,
  date: DateTime.parse(json['date'] as String),
  description: json['description'] as String?,
  notionId: json['notionId'] as String?,
  currency: json['currency'] as String? ?? '\$',
  accountId: json['accountId'] as String? ?? 'default',
);

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'amount': instance.amount,
  'category': instance.category,
  'date': instance.date.toIso8601String(),
  'description': instance.description,
  'notionId': instance.notionId,
  'currency': instance.currency,
  'accountId': instance.accountId,
};
