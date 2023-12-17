import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:budget_tracker/models/expense.dart';

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
