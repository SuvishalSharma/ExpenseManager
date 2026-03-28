import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/providers/expenses_stream_provider.dart';
import 'package:demo/providers/categories_stream_provider.dart';

final categoryTotalsByNameProvider = Provider<Map<String, int>>((ref) {
  final expensesAsync = ref.watch(expensesStreamProvider);
  final categoriesAsync = ref.watch(categoriesStreamProvider);

  if (expensesAsync.isLoading ||
      categoriesAsync.isLoading ||
      expensesAsync.hasError ||
      categoriesAsync.hasError) {
    return {};
  }

  final expenses = expensesAsync.value ?? [];
  final categories = categoriesAsync.value ?? [];

  final Map<int, String> categoryNames = {
    for (final category in categories) category.id: category.categoryName,
  };

  final Map<String, int> totals = {};

  for (final expense in expenses) {
    final categoryName = categoryNames[expense.categoryId] ?? 'Unknown';

    totals.update(
      categoryName,
      (value) => value + (expense.amount as int),
      ifAbsent: () => expense.amount as int,
    );
  }

  return totals;
});
