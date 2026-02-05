import 'package:drift/drift.dart';

import '../database/app_database.dart';

class ExpensesRepo {
  final AppDatabase db;
  ExpensesRepo(this.db);

  Stream<List<Expense>> watchAllExpenses() {
    return db.select(db.expenses).watch();
  }

  Future<void> addExpense(int amount, int categoryId, DateTime dateTime) async {
    if (amount <= 0) {
      throw Exception("Invalid amount");
    }
    final category = await (db.select(
      db.categories,
    )..where((c) => c.id.equals(categoryId))).getSingleOrNull();

    if (category == null) {
      throw Exception('Invalid Category');
    }

    await (db
        .into(db.expenses)
        .insert(
          ExpensesCompanion(
            amount: Value(amount),
            categoryId: Value(categoryId),
            date: Value(dateTime),
          ),
        ));
  }

  Future<void> deleteExpense(int expenseId) async {
    final expense = await (db.select(
      db.expenses,
    )..where((e) => e.id.equals(expenseId))).getSingleOrNull();

    if (expense == null) {
      return;
    }

    await (db.delete(db.expenses)..where((e) => e.id.equals(expenseId))).go();
  }

  Future<void> updateExpense(
    int expenseId,
    int amount,
    int categoryId,
    DateTime dateTime,
  ) async {
    final expense = await (db.select(
      db.expenses,
    )..where((e) => e.id.equals(expenseId))).getSingleOrNull();

    if (expense == null) throw Exception("Invalid Expense");

    if (amount <= 0) {
      throw Exception("Invalid amount");
    }
    final category = await (db.select(
      db.categories,
    )..where((c) => c.id.equals(categoryId))).getSingleOrNull();

    if (category == null) throw Exception("Invalid Category");

    await (db.update(db.expenses)..where((e) => e.id.equals(expenseId))).write(
      ExpensesCompanion(
        amount: Value(amount),
        categoryId: Value(categoryId),
        date: Value(dateTime),
      ),
    );
  }
}
