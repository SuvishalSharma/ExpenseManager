import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import 'expenses_repo_provider.dart';

final expensesStreamProvider = StreamProvider<List<Expense>>((ref) {
  final repo = ref.watch(expensesRepoProvider);
  return repo.watchAllExpenses();
});
