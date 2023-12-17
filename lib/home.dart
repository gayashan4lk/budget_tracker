import 'package:budget_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Expense> _dummyExpenses = [
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

  void _openAddExpensesOverlay() {
    showModalBottomSheet(context: context, builder: (ctx) => const NewExpense());
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
            child: ExpensesList(expenses: _dummyExpenses),
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

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) => ExpenseItem(expense: expenses[index]),
    );
  }
}

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({super.key, required this.expense});

  final Expense expense;

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
          onPressed: () => {
            print('delete ${expense.id}'),
          },
        ),
      ),
    );
  }
}

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  var _title = '';
  void _handleOnChanged(String value) {
    _title = value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: _handleOnChanged,
              maxLength: 50,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            Row(children: [
              ElevatedButton(
                onPressed: () {
                  print(_title);
                },
                child: Text('Save'),
              ),
            ]),
          ],
        ));
  }
}
