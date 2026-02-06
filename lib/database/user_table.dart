import 'package:drift/drift.dart';

class UserTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get passwordHash => text()();
  TextColumn get phone => text().nullable()();
  BoolColumn get isLoggedIn => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [{email}];
}