import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_controller_provider.dart';
import '../providers/auth_state_provider.dart';
import '../UI/login_screen.dart';
import '../UI/welcome_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    switch (authState.status) {
      case AuthStatus.loading:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );

      case AuthStatus.authenticated:
        return const WelcomeScreen();

      case AuthStatus.unauthenticated:
        return const LoginScreen();
    }
  }
}
