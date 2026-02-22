// import 'package:drift/drift.dart';
import 'package:drift/drift.dart';
import '../core/security/password_hasher.dart';
import '../database/app_database.dart';
import '../core/result.dart';
import '../models/user.dart';
import 'mappers/user_mapper.dart';

class AuthRepo {
  final AppDatabase db;
  AuthRepo(this.db);

  Future<Result<bool>> register({
    required String email,
    required String name,
    required String password,
    String? phone,
  }) async {
    final passwordHash = PasswordHasher.hash(password);
    try {
      await db
          .into(db.userTable)
          .insert(
            UserTableCompanion.insert(
              name: name,
              email: email,
              passwordHash: passwordHash,
              phone: Value(phone),
              isLoggedIn: const Value(false),
            ),
          );
      return Result.success(true);
    } catch (e) {
      return Result.failure('Email already exists');
    }
  }

  Future<Result<User>> login(String email, String password) async {
    return await db.transaction(() async {
      final users = await (db.select(
        db.userTable,
      )..where((u) => u.email.equals(email))).get();
      if (users.isEmpty) return Result.failure('User not found');
      final userRow = users.first;
      final inputHash = PasswordHasher.hash(password);

      if (userRow.passwordHash != inputHash) {
        return Result.failure('Invalid Password');
      }
      await db
          .update(db.userTable)
          .write(const UserTableCompanion(isLoggedIn: Value(false)));
      await (db.update(db.userTable)..where((u) => u.id.equals(userRow.id)))
          .write(const UserTableCompanion(isLoggedIn: Value(true)));
      return Result.success(userRow.toDomain());
    });
  }

  Future<Result<User>> getLoggedInUser() async {
    final users = await (db.select(
      db.userTable,
    )..where((u) => u.isLoggedIn.equals(true))).get();
    if (users.isEmpty) {
      return Result.success(null);
    } else if (users.length > 1) {
      throw Exception('Data Corruption : Multiple users logged in');
    }
    return Result.success(users.first.toDomain());
  }

  Future<Result<bool>> resetPassword(String email, String newPassword) async {
    try {
      // 1️⃣ Check if user exists
      final users = await (db.select(
        db.userTable,
      )..where((u) => u.email.equals(email))).get();

      if (users.isEmpty) {
        return Result.failure('User not found');
      }

      // 2️⃣ Hash new password
      final newHash = PasswordHasher.hash(newPassword);

      // 3️⃣ Update password in DB
      final rowsAffected =
          await (db.update(
            db.userTable,
          )..where((u) => u.email.equals(email))).write(
            UserTableCompanion(
              passwordHash: Value(newHash), // ✅ correct
              isLoggedIn: const Value(false), // force re-login
            ),
          );

      // 4️⃣ Verify update actually happened
      if (rowsAffected == 0) {
        return Result.failure('Password update failed');
      }

      return Result.success(true);
    } catch (e) {
      return Result.failure('Something went wrong: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await (db.update(
      db.userTable,
    )).write(const UserTableCompanion(isLoggedIn: Value(false)));
  }
}
