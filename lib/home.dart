import 'package:flutter/material.dart';

import 'package:budget_tracker/models/expense.dart';
import 'package:intl/intl.dart';

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

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addExpense});

  final Function addExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  late Function addExpense;

  @override
  void initState() {
    super.initState();
    addExpense = widget.addExpense;
  }

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? pickedDate;
  Category? selectedCategory;

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void submit() {
    if (!isValidUserInput()) {
      return;
    }

    var newExpense = Expense(
      title: titleController.text,
      amount: double.tryParse(amountController.text)!,
      date: pickedDate!,
      category: selectedCategory!,
    );

    addExpense(newExpense);
    Navigator.pop(context);
  }

  bool isValidUserInput() {
    final enteredAmount = double.tryParse(amountController.text);
    final isAmountValid = enteredAmount != null && enteredAmount > 0;

    if (titleController.text.trim().isEmpty || !isAmountValid || pickedDate == null || selectedCategory == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
            title: const Text('Invalid input'),
            content: const Text('Please make sure a valid title, amount, date and category was entered.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              )
            ]),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              maxLength: 50,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: amountController,
              maxLength: 10,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$ '),
            ),
            Row(
              children: [
                Text(pickedDate == null ? 'Select a Date' : DateFormat.yMd().format(pickedDate!)),
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    final now = DateTime.now();
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: now,
                      firstDate: DateTime(now.year - 99, now.month, now.day),
                      lastDate: now,
                    );
                    setState(() {
                      this.pickedDate = pickedDate;
                    });
                  },
                ),
                const Spacer(),
                DropdownButton(
                    hint: const Text(' Select a category '),
                    value: selectedCategory,
                    items: Category.values
                        .map((category) => DropdownMenuItem(
                            value: category,
                            child: Row(
                              children: [
                                Icon(categoryIcons[category]),
                                const SizedBox(width: 5),
                                Text(category.name.toString()),
                              ],
                            )))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    }),
              ],
            ),
            const SizedBox(height: 20),
            Row(children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: submit,
                child: const Text('Save'),
              ),
            ]),
          ],
        ));
  }
}
