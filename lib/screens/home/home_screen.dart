import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finance_tracker/bloc/theme_cubit.dart';
import 'widgets/balance_section.dart';
import 'widgets/filter_section.dart';
import 'widgets/date_filter_section.dart';
import 'widgets/transaction_table.dart';
import 'widgets/spending_chart.dart';
import 'widgets/add_transaction_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          )
        ],
      ),
      body: Column(
        children: const [
          BalanceSection(),
          SizedBox(height: 8),
          FilterSection(),
          SizedBox(height: 8),
          DateFilterSection(),
          SizedBox(height: 8),
          Expanded(child: TransactionTable()),
          SpendingChart(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () => showAddTransactionDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
