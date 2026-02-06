import 'package:demo/UI/add_expense_screen.dart';
import 'package:demo/providers/categories_repo_provider.dart';
import 'package:demo/providers/expense_action_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expenses_stream_provider.dart';
import 'edit_expense_screen.dart';
import '../providers/categoy_wise_total_provider.dart';

class ExpenseListScreen extends ConsumerWidget {
  const ExpenseListScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(categorySeedProvider);
    final expensesAsync = ref.watch(expensesStreamProvider);
    ref.watch(expenseActionProvider);
    final categoryTotals = ref.watch(categoryTotalsByNameProvider);
    final total = ref.watch(totalAmountProvider);
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
      body: Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total : ₹$total',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height:12),
                ...categoryTotals.entries.map((entry){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Text('₹${entry.value}'),
                    ],
                  );
                }),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: expensesAsync.when(
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
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _confirmDelete(context, ref, expense.id);
                        },
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EditExpenseScreen(expenseId: expense.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    int expenseId,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      ref.read(expenseActionProvider.notifier).deleteExpense(expenseId);
    }
  }
}
