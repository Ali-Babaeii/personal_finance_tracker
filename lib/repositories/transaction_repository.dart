import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';

class TransactionRepository {
  static const _boxName = 'transactions';
  late final Box<TransactionModel> _box;

  Future<void> init() async {
    _box = await Hive.openBox<TransactionModel>(_boxName);
    // Hive box to persist transactions offline
  }

  List<TransactionModel> getAllTransactions() => _box.values.toList();

  Future<void> addTransaction(TransactionModel transaction) =>
      _box.put(transaction.id, transaction);

  Future<void> deleteTransaction(String id) => _box.delete(id);

  Future<void> updateTransaction(TransactionModel transaction) =>
      _box.put(transaction.id, transaction);
}
