import 'package:uuid/uuid.dart';

enum Category { food, transportation, personal, other }

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
}
