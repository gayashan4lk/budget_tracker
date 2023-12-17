import 'package:uuid/uuid.dart';

class Expense {
  Expense({
    String? id,
    required this.title,
    required this.amount,
    required this.date,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
}
