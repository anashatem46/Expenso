// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
  id: json['id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  balance: (json['balance'] as num).toDouble(),
  number: json['number'] as String,
  iconCodePoint: (json['iconCodePoint'] as num).toInt(),
  colorValue: (json['colorValue'] as num).toInt(),
);

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'balance': instance.balance,
  'number': instance.number,
  'iconCodePoint': instance.iconCodePoint,
  'colorValue': instance.colorValue,
};
