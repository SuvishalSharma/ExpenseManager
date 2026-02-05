import 'package:demo/UI/add_expense_screen.dart';
import 'package:demo/providers/categories_repo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expenses_stream_provider.dart';

class ExpenseListScreen extends ConsumerWidget {
  const ExpenseListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(categorySeedProvider);
    final expensesAsync = ref.watch(expensesStreamProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
              );
            },
          ),
        ],
      ),
      body: expensesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (expenses) {
          if (expenses.isEmpty) {
            return const Center(child: Text('No expenses yet'));
          }
          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return ListTile(
                title: Text('Amount: ${expense.amount}'),
                subtitle: Text(expense.date.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
