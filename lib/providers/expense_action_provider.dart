import 'package:demo/providers/expenses_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repo/expenses_repo.dart';

class ExpenseActionState {
  final bool isLoading;
  final String? error;

  const ExpenseActionState({this.isLoading = false, this.error});
}

class ExpenseActionNotifier extends StateNotifier<ExpenseActionState> {
  final ExpensesRepo _expensesRepo;
  ExpenseActionNotifier(this._expensesRepo) : super(const ExpenseActionState());

  Future<void> addExpense(int amount, int categoryId, DateTime dateTime) async {
    state = const ExpenseActionState(isLoading: true);
    try {
      await _expensesRepo.addExpense(amount, categoryId, dateTime);
      state = const ExpenseActionState();
    } catch (e) {
      state = ExpenseActionState(error: e.toString());
    }
  }

  Future<void> deleteExpense(int expenseId) async {
    state = const ExpenseActionState(isLoading: true);
    try {
      await _expensesRepo.deleteExpense(expenseId);
      state = const ExpenseActionState();
    } catch (e) {
      state = ExpenseActionState(error: e.toString());
    }
  }

  Future<void> updateExpense(
    int expenseId,
    int amount,
    int categoryId,
    DateTime dateTime,
  ) async {
    state = const ExpenseActionState(isLoading: true);
    try {
      await _expensesRepo.updateExpense(
        expenseId,
        amount,
        categoryId,
        dateTime,
      );
      state = const ExpenseActionState();
    } catch (e) {
      state = ExpenseActionState(error: e.toString());
    }
  }
}

final expenseActionProvider =
    StateNotifierProvider<ExpenseActionNotifier, ExpenseActionState>((ref) {
      final expenseRepo = ref.watch(expensesRepoProvider);
      return ExpenseActionNotifier(expenseRepo);
    });
