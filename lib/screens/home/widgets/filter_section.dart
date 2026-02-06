import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/bloc/transaction_cubit.dart';
import 'package:personal_finance_tracker/models/transaction.dart';

class FilterSection extends StatelessWidget {
  const FilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        // Filter buttons for All / Income / Expense
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _filterButton(context, 'All', null, state),
            const SizedBox(width: 8),
            _filterButton(context, 'Income', TransactionType.income, state),
            const SizedBox(width: 8),
            _filterButton(context, 'Expense', TransactionType.expense, state),
          ],
        );
      },
    );
  }

  Widget _filterButton(BuildContext context, String label,
      TransactionType? type, TransactionState state) {
    final bool selected =
        (type == null && state.filter == null) || (state.filter == type);

    return TextButton(
      onPressed: () => context.read<TransactionCubit>().setFilter(type),
      style: TextButton.styleFrom(
        backgroundColor: selected ? Colors.blue : Colors.grey[200],
      ),
      child: Text(
        label,
        style: TextStyle(color: selected ? Colors.white : Colors.black),
      ),
    );
  }
}
