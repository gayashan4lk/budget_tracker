import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

enum Category { food, transportation, personal, other }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.transportation: Icons.train,
  Category.personal: Icons.person,
  Category.other: Icons.money,
};

class Expense {
  Expense({
    String? id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return DateFormat.yMd().format(date);
  }
}
