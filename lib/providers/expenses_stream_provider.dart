import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import 'expenses_repo_provider.dart';
import 'auth_controller_provider.dart';

final expensesStreamProvider = StreamProvider<List<Expense>>((ref) {
  final authState = ref.watch(authControllerProvider);

  if (authState.user == null) {
    return const Stream.empty();
  }

  final repo = ref.watch(expensesRepoProvider);
  return repo.watchExpensesByUser(authState.user!.id);
});

final expenseByIdProvider = StreamProvider.family<Expense?, int>((
  ref,
  expenseId,
) {
  final authState = ref.watch(authControllerProvider);

  if (authState.user == null) {
    return const Stream.empty();
  }

  final repo = ref.watch(expensesRepoProvider);
  return repo.watchExpenseByIdForUser(expenseId, authState.user!.id);
});
