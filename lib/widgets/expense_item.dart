import 'package:flutter/material.dart';

import 'package:budget_tracker/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({super.key, required this.expense, required this.deleteExpense});

  final Expense expense;
  final Function deleteExpense;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: ListTile(
        leading: SizedBox(
          width: 100,
          child: Text(
            '\$${expense.amount.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(categoryIcons[expense.category]),
            const SizedBox(width: 5),
            Text(expense.formattedDate, style: const TextStyle(fontSize: 10)),
          ],
        ),
        trailing: IconButton(
          iconSize: 20,
          icon: const Icon(Icons.delete),
          onPressed: () => {deleteExpense(expense.id)},
        ),
      ),
    );
  }
}
