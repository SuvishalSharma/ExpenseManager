import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';
import '../providers/expenses_stream_provider.dart';
import '../providers/expense_action_provider.dart';
import '../providers/categories_stream_provider.dart';

class EditExpenseScreen extends ConsumerStatefulWidget {
  final int expenseId;
  const EditExpenseScreen({required this.expenseId, super.key});
  @override
  ConsumerState<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends ConsumerState<EditExpenseScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  Category? selectedCategory;
  bool _initialized = false;
  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expenseByIdProvider(widget.expenseId));
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final actionState = ref.watch(expenseActionProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Edit Expense')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: expensesAsync.when(
          loading: () => Center(child: const CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (expense) {
            if (expense == null) {
              return const Center(child: Text('Expense not found'));
            }
            return categoriesAsync.when(
              loading: () => Center(child: const CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (categories) {
                if (!_initialized) {
                  amountController.text = expense.amount.toString();
                  selectedCategory = categories.firstWhere(
                    (c) => c.id == expense.categoryId,
                  );
                  _initialized = true;
                }
                return Form(
                  key: _key,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Amount',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter amount';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Numbers only';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<Category>(
                        initialValue: selectedCategory,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Category',
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.categoryName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Select category' : null,
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: actionState.isLoading
                            ? null
                            : () {
                                if (_key.currentState!.validate()) {
                                  final amount = int.parse(
                                    amountController.text,
                                  );
                                  ref
                                      .read(expenseActionProvider.notifier)
                                      .updateExpense(
                                        widget.expenseId,
                                        amount,
                                        selectedCategory!.id,
                                        DateTime.now(),
                                      );
                                  Navigator.pop(context);
                                }
                              },
                        child: actionState.isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Update'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

 
}
