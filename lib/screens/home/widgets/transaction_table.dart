import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_tracker/bloc/transaction_cubit.dart';
import 'package:personal_finance_tracker/models/transaction.dart';

import 'edit_transaction_dialog.dart';

class TransactionTable extends StatelessWidget {
  const TransactionTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final transactions = state.filteredTransactions;
        if (transactions.isEmpty) {
          return const Center(child: Text('No Transactions!'));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Category')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Note')),
              DataColumn(label: Text('Actions')),
            ],
            rows: transactions.map((t) {
              return DataRow(cells: [
                DataCell(Text(DateFormat.yMd().format(t.date))),
                DataCell(Text(t.category)),
                DataCell(Text(
                    t.type == TransactionType.income ? 'Income' : 'Expense')),
                DataCell(Text(
                  '${t.type == TransactionType.income ? '+' : '-'} €${t.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: t.type == TransactionType.income
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                DataCell(Text(t.note ?? '')),
                DataCell(Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => showEditTransactionDialog(context, t),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => context
                          .read<TransactionCubit>()
                          .deleteTransaction(t.id),
                    ),
                  ],
                )),
              ]);
            }).toList(),
          ),
        );
      },
    );
  }
}
