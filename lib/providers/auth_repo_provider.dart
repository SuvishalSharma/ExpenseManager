import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'db_provider.dart';
import '../repo/auth_repo.dart';
final authRepoProvider = Provider<AuthRepo>((ref) {
  final db = ref.read(dbProvider);
  return AuthRepo(db);
});
