import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/bloc/transaction_cubit.dart';

import 'package:personal_finance_tracker/models/transaction.dart';

void showEditTransactionDialog(BuildContext context, TransactionModel t) {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController(text: t.amount.toString());
  final categoryController = TextEditingController(text: t.category);
  final noteController = TextEditingController(text: t.note ?? '');
  TransactionType type = t.type;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Edit Transaction'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Amount'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Amount required';
                final val = double.tryParse(value);
                if (val == null || val <= 0) return 'Enter valid amount';
                return null;
              },
            ),
            TextFormField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Category required';
                return null;
              },
            ),
            TextFormField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Note'),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _typeButton(() => type = TransactionType.income, type,
                    TransactionType.income, 'Income'),
                const SizedBox(width: 8),
                _typeButton(() => type = TransactionType.expense, type,
                    TransactionType.expense, 'Expense'),
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
            )),
        ElevatedButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            final updated = t.copyWith(
              amount: double.parse(amountController.text),
              category: categoryController.text,
              note: noteController.text,
              type: type,
            );

            await context.read<TransactionCubit>().updateTransaction(updated);

            Navigator.pop(context);
          },
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ],
    ),
  );
}

Widget _typeButton(VoidCallback onTap, TransactionType current,
    TransactionType target, String label) {
  final bool selected = current == target;
  return ElevatedButton(
    onPressed: onTap,
    style: ElevatedButton.styleFrom(
      backgroundColor: selected ? Colors.blue : Colors.grey[300],
    ),
    child: Text(label,
        style: TextStyle(color: selected ? Colors.white : Colors.black)),
  );
}
