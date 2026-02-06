import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';

class TransactionState {
  final List<TransactionModel> transactions;
  final TransactionType? filter;
  final DateTime? startDate;
  final DateTime? endDate;

  TransactionState({
    required this.transactions,
    this.filter,
    this.startDate,
    this.endDate,
  });

  double get balance => transactions.fold(
      0,
      (prev, t) =>
          t.type == TransactionType.income ? prev + t.amount : prev - t.amount);

  List<TransactionModel> get filteredTransactions {
    var filtered = transactions;

// If user picked a range, update cubit state
    if (filter != null) {
      filtered = filtered.where((t) => t.type == filter).toList();
    }

    if (startDate != null && endDate != null) {
      filtered = filtered
          .where((t) =>
              t.date.isAfter(startDate!.subtract(const Duration(days: 1))) &&
              t.date.isBefore(endDate!.add(const Duration(days: 1))))
          .toList();
    }

    return filtered;
  }
}

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository repository;

  TransactionCubit(this.repository)
      : super(TransactionState(transactions: repository.getAllTransactions()));

// Add a new transaction to Hive and update state
  Future<void> addTransaction(
      double amount, String category, TransactionType type,
      {String? note}) async {
    final transaction = TransactionModel(
      id: const Uuid().v4(), // Unique ID for each transaction
      amount: amount,
      category: category,
      date: DateTime.now(),
      note: note,
      type: type,
    );

    await repository.addTransaction(transaction); // Save locally
    emit(TransactionState(
        transactions: repository.getAllTransactions(),
        filter: state.filter,
        startDate: state.startDate,
        endDate: state.endDate));
  }

  Future<void> deleteTransaction(String id) async {
    await repository.deleteTransaction(id);
    emit(TransactionState(
        transactions: repository.getAllTransactions(),
        filter: state.filter,
        startDate: state.startDate,
        endDate: state.endDate));
  }

  Future<void> updateTransaction(TransactionModel updated) async {
    await repository.updateTransaction(updated);
    emit(TransactionState(
        transactions: repository.getAllTransactions(),
        filter: state.filter,
        startDate: state.startDate,
        endDate: state.endDate));
  }

  void setFilter(TransactionType? type) {
    emit(TransactionState(
        transactions: state.transactions,
        filter: type,
        startDate: state.startDate,
        endDate: state.endDate));
  }

  void setDateRange(DateTime? start, DateTime? end) {
    emit(TransactionState(
        transactions: state.transactions,
        filter: state.filter,
        startDate: start,
        endDate: end));
  }

  void clearDateRange() {
    emit(TransactionState(
        transactions: state.transactions,
        filter: state.filter,
        startDate: null,
        endDate: null));
  }
}
