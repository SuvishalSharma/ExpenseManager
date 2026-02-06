import '../database/app_database.dart';

class CategoriesRepo {
  final AppDatabase db;
  CategoriesRepo(this.db);

  Stream<List<Category>> watchAllCategories() {
    return db.select(db.categories).watch();
  }

  Future<void> seedDefaultCategories() async {
    final existing = await db.select(db.categories).get();

    if (existing.isNotEmpty) return;

    await db.batch((batch) {
      batch.insertAll(db.categories, [
        CategoriesCompanion.insert(categoryName: 'Food'),
        CategoriesCompanion.insert(categoryName: 'Drinks'),
        CategoriesCompanion.insert(categoryName: 'Movies'),
        CategoriesCompanion.insert(categoryName: 'Hotels'),
      ]);
    });
  }
}