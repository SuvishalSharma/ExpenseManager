import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'expenses_stream_provider.dart';
import 'categories_stream_provider.dart';
// import '../database/app_database.dart';
final categoryTotalsByNameProvider = Provider<Map<String,int>>((ref){
  final expensesAsync = ref.watch(expensesStreamProvider);
  final categoriesAsync = ref.watch(categoriesStreamProvider);

  if(expensesAsync.isLoading || categoriesAsync.isLoading || categoriesAsync.hasError || expensesAsync.hasError) return {};
  final expenses = expensesAsync.value ?? [];
  final categories = categoriesAsync.value ?? [];

  final Map<int,String> categoryNames = {
    for (final category in categories)
    category.id:category.categoryName,
  };
  final Map<String,int> totals = {};
  for(final expense in expenses){
    final categoryName = categoryNames[expense.categoryId] ?? 'Unknown' ;
    totals.update(categoryName, (value)=>value+expense.amount, ifAbsent: () => expense.amount,);
  }
  return totals;
});


