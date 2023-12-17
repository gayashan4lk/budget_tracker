import 'package:flutter/material.dart';

import 'package:budget_tracker/models/expense.dart';
import 'widgets/new_expense.dart';
import 'widgets/expense_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Expense> _dummyExpenses = [
    Expense(title: "Flutter course", amount: 19.99, date: DateTime.now(), category: Category.personal),
    Expense(title: "Lunch", amount: 5.00, date: DateTime.now(), category: Category.food),
    Expense(title: "Train", amount: 2.50, date: DateTime.now(), category: Category.transportation),
    Expense(title: "Shopping", amount: 15.50, date: DateTime.now(), category: Category.other),
    Expense(title: "Gas", amount: 330.00, date: DateTime.now(), category: Category.transportation),
    Expense(title: "Movie", amount: 12.75, date: DateTime.now(), category: Category.personal),
    Expense(title: "Dinner", amount: 29241.00, date: DateTime.now(), category: Category.food),
    Expense(title: "Books", amount: 40.25, date: DateTime.now(), category: Category.personal),
    Expense(title: "Gym membership", amount: 50.00, date: DateTime.now(), category: Category.personal),
    Expense(title: "Concert tickets", amount: 75.50, date: DateTime.now(), category: Category.other),
  ];

  void addExpense(Expense expense) {
    _dummyExpenses.add(expense);
    setState(() {
      _dummyExpenses = _dummyExpenses;
    });
  }

  void deleteExpense(String id) {
    _dummyExpenses.removeWhere((expense) => expense.id == id);
    setState(() {
      _dummyExpenses = _dummyExpenses;
    });
  }

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewExpense(addExpense: addExpense),
      showDragHandle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const Text('Chart'),
          Expanded(
            child: ExpensesList(expenses: _dummyExpenses, deleteExpense: deleteExpense),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpensesOverlay,
        tooltip: 'Add an expense',
        child: const Icon(Icons.add),
      ),
    );
  }
}
