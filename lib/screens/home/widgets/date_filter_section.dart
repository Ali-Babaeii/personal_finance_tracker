import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_tracker/bloc/transaction_cubit.dart';

class DateFilterSection extends StatelessWidget {
  const DateFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        String rangeText;
        if (state.startDate != null && state.endDate != null) {
          rangeText =
              '${DateFormat.yMd().format(state.startDate!)} - ${DateFormat.yMd().format(state.endDate!)}';
        } else {
          rangeText = 'Filter by Date';
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                // If user picked a range, update cubit state
                if (picked != null) {
                  context
                      .read<TransactionCubit>()
                      .setDateRange(picked.start, picked.end);
                }
              },
              icon: const Icon(Icons.filter_alt, color: Colors.blueAccent),
              label: Text(rangeText,
                  style: const TextStyle(color: Colors.blueAccent)),
            ),
            const SizedBox(width: 8),
            if (state.startDate != null || state.endDate != null)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () =>
                    context.read<TransactionCubit>().clearDateRange(),
              ),
          ],
        );
      },
    );
  }
}
