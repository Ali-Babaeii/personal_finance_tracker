import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/bloc/transaction_cubit.dart';
import 'package:personal_finance_tracker/models/transaction.dart';

void showAddTransactionDialog(BuildContext context) {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  final noteController = TextEditingController();
  TransactionType type = TransactionType.expense;

  showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Add Transaction'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Category is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount (€)',
                  prefixText: '€',
                ),
                validator: (value) {
                  final amount = double.tryParse(value ?? '');
                  if (amount == null || amount <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: type == TransactionType.income
                          ? Colors.blue
                          : Colors.grey[200],
                    ),
                    onPressed: () =>
                        setState(() => type = TransactionType.income),
                    child: Text(
                      'Income',
                      style: TextStyle(
                          color: type == TransactionType.income
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: type == TransactionType.expense
                          ? Colors.blue
                          : Colors.grey[200],
                    ),
                    onPressed: () =>
                        setState(() => type = TransactionType.expense),
                    child: Text(
                      'Expense',
                      style: TextStyle(
                          color: type == TransactionType.expense
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final amount = double.parse(amountController.text);

                await context.read<TransactionCubit>().addTransaction(
                      amount,
                      categoryController.text,
                      type,
                      note: noteController.text,
                    );

                Navigator.pop(context);
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    ),
  );
}
