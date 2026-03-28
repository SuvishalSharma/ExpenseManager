import 'package:drift/drift.dart';
import '../database/app_database.dart';

class ExpensesRepo {
  final AppDatabase db;
  ExpensesRepo(this.db);

  Stream<List<Expense>> watchExpensesByUser(int userId) {
    return (db.select(
      db.expenses,
    )..where((e) => e.userId.equals(userId))).watch();
  }

  Future<void> addExpense(
    int amount,
    int categoryId,
    DateTime dateTime,
    int userId,
  ) async {
    if (amount <= 0) {
      throw Exception("Invalid amount");
    }

    final category = await (db.select(
      db.categories,
    )..where((c) => c.id.equals(categoryId))).getSingleOrNull();

    if (category == null) {
      throw Exception('Invalid Category');
    }

    final user = await (db.select(
      db.userTable,
    )..where((u) => u.id.equals(userId))).getSingleOrNull();

    if (user == null) {
      throw Exception('Invalid User');
    }

    await db
        .into(db.expenses)
        .insert(
          ExpensesCompanion.insert(
            amount: amount,
            categoryId: categoryId,
            date: dateTime,
            userId: userId,
          ),
        );
  }

  Future<void> deleteExpense(int expenseId, int userId) async {
    await (db.delete(
      db.expenses,
    )..where((e) => e.id.equals(expenseId) & e.userId.equals(userId))).go();
  }

  Future<void> updateExpense(
    int expenseId,
    int amount,
    int categoryId,
    DateTime dateTime,
    int userId,
  ) async {
    if (amount <= 0) {
      throw Exception("Invalid amount");
    }

    final category = await (db.select(
      db.categories,
    )..where((c) => c.id.equals(categoryId))).getSingleOrNull();

    if (category == null) throw Exception("Invalid Category");

    await (db.update(
      db.expenses,
    )..where((e) => e.id.equals(expenseId) & e.userId.equals(userId))).write(
      ExpensesCompanion(
        amount: Value(amount),
        categoryId: Value(categoryId),
        date: Value(dateTime),
      ),
    );
  }

  Stream<Expense?> watchExpenseByIdForUser(int expenseId, int userId) {
    return (db.select(db.expenses)
          ..where((e) => e.id.equals(expenseId) & e.userId.equals(userId)))
        .watchSingleOrNull();
  }
}
