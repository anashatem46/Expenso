import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'expense.dart'; // For SyncStatus

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

  // New fields for synchronization
  final DateTime lastModified;
  final bool isDeleted;
  final SyncStatus syncStatus;

  Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.number,
    required this.iconCodePoint,
    required this.colorValue,
    required this.lastModified,
    this.isDeleted = false,
    this.syncStatus = SyncStatus.pending,
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

  // For SQLite
  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      balance: map['balance'],
      number: map['number'],
      iconCodePoint: map['iconCodePoint'],
      colorValue: map['colorValue'],
      lastModified: DateTime.parse(map['lastModified']),
      isDeleted: map['isDeleted'] == 1,
      syncStatus: SyncStatus.values[map['syncStatus']],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'balance': balance,
      'number': number,
      'iconCodePoint': iconCodePoint,
      'colorValue': colorValue,
      'lastModified': lastModified.toIso8601String(),
      'isDeleted': isDeleted ? 1 : 0,
      'syncStatus': syncStatus.index,
    };
  }

  Account copyWith({
    String? id,
    String? name,
    String? type,
    double? balance,
    String? number,
    int? iconCodePoint,
    int? colorValue,
    DateTime? lastModified,
    bool? isDeleted,
    SyncStatus? syncStatus,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      number: number ?? this.number,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      lastModified: lastModified ?? this.lastModified,
      isDeleted: isDeleted ?? this.isDeleted,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  String toString() {
    return 'Account(id: $id, name: $name, type: $type, balance: $balance, number: $number, lastModified: $lastModified, isDeleted: $isDeleted, syncStatus: $syncStatus)';
  }
}
