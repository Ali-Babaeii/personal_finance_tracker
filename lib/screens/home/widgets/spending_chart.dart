import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:personal_finance_tracker/bloc/transaction_cubit.dart';
import 'package:personal_finance_tracker/models/transaction.dart';

class SpendingChart extends StatelessWidget {
  const SpendingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final transactions = state.filteredTransactions;

        final expenses = transactions
            .where((t) => t.type == TransactionType.expense)
            .toList();
        if (expenses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No expense data for chart'),
          );
        }

        final Map<String, double> categoryTotals = {};
        for (final t in expenses) {
          categoryTotals[t.category] =
              (categoryTotals[t.category] ?? 0) + t.amount;
        }

        final colors = [
          Colors.blue,
          Colors.red,
          Colors.green,
          Colors.orange,
          Colors.purple,
          Colors.teal
        ];
        int colorIndex = 0;

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Text(
                'Spending by Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 300,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 50,
                  sectionsSpace: 4,
                  sections: categoryTotals.entries.map((entry) {
                    final color = colors[colorIndex++ % colors.length];
                    return PieChartSectionData(
                      value: entry.value,
                      title: '${entry.key}\n€${entry.value.toStringAsFixed(0)}',
                      radius: 100,
                      color: color,
                      titleStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
        );
      },
    );
  }
}
