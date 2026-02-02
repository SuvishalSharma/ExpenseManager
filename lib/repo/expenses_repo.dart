import 'package:drift/drift.dart';

import '../database/app_database.dart';

class ExpensesRepo {
  AppDatabase db;
  ExpensesRepo(this.db);

  Stream<List<Expense>> watchAllExpenses() {
    return db.select(db.expenses).watch();
  }

  Future<void> addExpense(int amount, int categoryId, DateTime dateTime) async {
    // final row = await(db.select(db.expenses)..where((t)=>t.id.equals(amount))).getSingleOrNull();
    if (amount <= 0) {
      throw Exception(
        "Not accepted with invalid format check amount/date time format/ category id exist",
      );
    } else {
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
  }
}
