import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import 'expenses_repo_provider.dart';
// import 'categories';
final expensesStreamProvider = StreamProvider<List<Expense>>((ref) {
  final repo = ref.watch(expensesRepoProvider);
  return repo.watchAllExpenses();
});

final expenseByIdProvider = StreamProvider.family<Expense?, int>((ref, expenseId){
  final repo = ref.watch(expensesRepoProvider);
  return repo.watchExpenseById(expenseId);
});

final totalAmountProvider = Provider<int>((ref){
  final expensesAsync = ref.watch(expensesStreamProvider);
  return expensesAsync.when(
    data: (expenses){
      return expenses.fold(0, (sum,e)=>sum + e.amount);
    },
    loading: () => 0,
    error: (_,_)=>0
  );
}); 