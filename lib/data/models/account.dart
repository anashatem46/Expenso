import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'account.g.dart';

@JsonSerializable()
class Account {
  final String id;
  final String name;
  final String type; // 'wallet', 'bank', 'investment'
  final double balance;
  final String number;
  final int iconCodePoint;
  final int colorValue;

  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.number,
    required this.iconCodePoint,
    required this.colorValue,
  });

  // Helper getters for UI
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  MaterialColor get color => MaterialColor(colorValue, <int, Color>{
    50: Color(colorValue).withOpacity(0.1),
    100: Color(colorValue).withOpacity(0.2),
    200: Color(colorValue).withOpacity(0.3),
    300: Color(colorValue).withOpacity(0.4),
    400: Color(colorValue).withOpacity(0.5),
    500: Color(colorValue),
    600: Color(colorValue).withOpacity(0.7),
    700: Color(colorValue).withOpacity(0.8),
    800: Color(colorValue).withOpacity(0.9),
    900: Color(colorValue),
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  Account copyWith({
    String? id,
    String? name,
    String? type,
    double? balance,
    String? number,
    int? iconCodePoint,
    int? colorValue,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      number: number ?? this.number,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
    );
  }

  @override
  String toString() {
    return 'Account(id: $id, name: $name, type: $type, balance: $balance, number: $number)';
  }
}
