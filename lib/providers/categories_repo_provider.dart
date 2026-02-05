import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repo/categories_repo.dart';
import 'db_provider.dart';

final categoriesRepoProvider = Provider<CategoriesRepo>((ref) {
  final db = ref.watch(dbProvider);
  return CategoriesRepo(db);
});
final categorySeedProvider = FutureProvider<void>((ref) async {
  final db = ref.watch(dbProvider);
  await CategoriesRepo(db).seedDefaultCategories();
});
