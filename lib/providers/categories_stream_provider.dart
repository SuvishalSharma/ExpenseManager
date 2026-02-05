import 'package:demo/providers/categories_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  final repo = ref.watch(categoriesRepoProvider);
  return repo.watchAllCategories();
});
