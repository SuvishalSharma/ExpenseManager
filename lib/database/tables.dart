import 'package:drift/drift.dart';

class Expenses extends Table{
  IntColumn get id => integer().autoIncrement()();
  IntColumn get amount => integer()();
  DateTimeColumn get date => dateTime()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Categories extends Table{
  IntColumn get id=>integer().autoIncrement()();
  TextColumn get name=>text()();
  BoolColumn get isActive=>boolean().withDefault(const Constant(true))();
}