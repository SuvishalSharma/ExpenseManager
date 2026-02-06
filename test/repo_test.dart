import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';

import 'package:demo/database/app_database.dart';
import 'package:demo/repo/expenses_repo.dart';

void main() {
  late AppDatabase db;
  late ExpensesRepo repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = ExpensesRepo(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('addExpense throws error when amount is zero or negative', () async {
    expect(
      () => repo.addExpense(0, 1, DateTime.now()),
      throwsException,
    );
  });
}
