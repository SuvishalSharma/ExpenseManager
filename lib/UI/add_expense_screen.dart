import 'package:demo/UI/expense_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:demo/providers/expense_action_provider.dart';
import '../providers/categories_stream_provider.dart';
import '../database/app_database.dart';
import '../providers/categories_repo_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const ExpenseListScreen());
  }
}

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController amountcontroller = TextEditingController();
  Category? selectedCategory;

  @override
  void dispose() {
    amountcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(categorySeedProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final actionState = ref.watch(expenseActionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Amount
              TextFormField(
                controller: amountcontroller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter amount';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter numbers only';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              /// Category Dropdown
              categoriesAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text(e.toString()),
                data: (categories) {
                  print('Categories count: ${categories.length}');
                  return DropdownButtonFormField<Category>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
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
                  );
                },
              ),

              const SizedBox(height: 24),

              /// Save Button
              ElevatedButton(
                onPressed: actionState.isLoading
                    ? null
                    : () {
                        if (_key.currentState!.validate()) {
                          final amount = int.parse(amountcontroller.text);

                          ref
                              .read(expenseActionProvider.notifier)
                              .addExpense(
                                amount,
                                selectedCategory!.id,
                                DateTime.now(),
                              );
                          Navigator.pop(context);
                        }
                      },
                child: actionState.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
