import 'package:flutter/material.dart';

import 'package:budget_tracker/models/expense.dart';
import 'expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenses, required this.deleteExpense});

  final List<Expense> expenses;
  final Function deleteExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => ExpenseItem(expense: expenses[index], deleteExpense: deleteExpense),
    );
  }
}
