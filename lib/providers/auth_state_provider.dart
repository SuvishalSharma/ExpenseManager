import '../models/user.dart';

enum AuthStatus {
  loading,
  authenticated,
  unauthenticated,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState({
    required this.status,
    this.user,
    this.error,
  });

  factory AuthState.loading() {
    return const AuthState(status: AuthStatus.loading);
  }

  factory AuthState.authenticated(User user) {
    return AuthState(
      status: AuthStatus.authenticated,
      user: user,
      error: null,
    );
  }

  factory AuthState.unauthenticated({String? error}) {
    return AuthState(
      status: AuthStatus.unauthenticated,
      user: null,
      error: error,
    );
  }
}
