import 'package:demo/providers/auth_repo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repo/auth_repo.dart';
import 'auth_state_provider.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthRepo _repo;

  AuthController(this._repo) : super(AuthState.loading()) {
    init();
  }

  // App start
  Future<void> init() async {
    try {
      final result = await _repo.getLoggedInUser();

      if (result.isSuccess && result.data != null) {
        state = AuthState.authenticated(result.data!);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.unauthenticated(error: e.toString());
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    state = AuthState.loading();

    final result = await _repo.login(email, password);

    if (result.isSuccess) {
      state = AuthState.authenticated(result.data!);
    } else {
      state = AuthState.unauthenticated(error: result.message);
    }
  }

  // Logout
  Future<void> logout() async {
    await _repo.logout();
    state = AuthState.unauthenticated();
  }

  // Register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final result = await _repo.register(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );

    return result.isSuccess;
  }

  // Reset password
  Future<bool> resetPassword(String email, String newPassword) async {
    final result = await _repo.resetPassword(email, newPassword);
    return result.isSuccess;
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repo = ref.read(authRepoProvider);
    return AuthController(repo);
  },
);
