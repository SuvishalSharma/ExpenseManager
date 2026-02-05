import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'db_provider.dart';
import '../repo/expenses_repo.dart';

final expensesRepoProvider = Provider<ExpensesRepo>((ref) {
  final db = ref.watch(dbProvider);
  return ExpensesRepo(db);
});
