import 'dart:async';
import 'package:fashion_flow/core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Enum representing the current authentication status.
enum AuthStatus {
  /// Initial state, checking authentication.
  initial,

  /// User is authenticated.
  authenticated,

  /// User is not authenticated.
  unauthenticated,
}

/// State class for authentication in the app.
class AppAuthState {
  final AuthStatus status;
  final supabase.User? user;

  const AppAuthState({required this.status, this.user});

  const AppAuthState.initial() : status = AuthStatus.initial, user = null;

  const AppAuthState.authenticated(this.user)
    : status = AuthStatus.authenticated;

  const AppAuthState.unauthenticated()
    : status = AuthStatus.unauthenticated,
      user = null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppAuthState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          user?.id == other.user?.id;

  @override
  int get hashCode => status.hashCode ^ (user?.id.hashCode ?? 0);
}

/// Provider for the current authentication state.
///
/// Listens to Supabase auth state changes and exposes the current
/// authentication status for use in routing and UI.
final authStateProvider = NotifierProvider<AuthStateNotifier, AppAuthState>(
  AuthStateNotifier.new,
);

/// Notifier that manages authentication state.
class AuthStateNotifier extends Notifier<AppAuthState> {
  StreamSubscription<supabase.AuthState>? _subscription;

  @override
  AppAuthState build() {
    final authRepo = ref.watch(authRepositoryProvider);

    // Check initial auth state
    final currentUser = authRepo.currentUser;
    if (currentUser != null) {
      return AppAuthState.authenticated(currentUser);
    }

    // Listen to auth state changes
    _listenToAuthChanges();

    return const AppAuthState.unauthenticated();
  }

  void _listenToAuthChanges() {
    final authRepo = ref.read(authRepositoryProvider);

    _subscription?.cancel();
    _subscription = authRepo.authStateChanges.listen((supabaseAuthState) {
      final session = supabaseAuthState.session;
      if (session != null) {
        state = AppAuthState.authenticated(session.user);
      } else {
        state = const AppAuthState.unauthenticated();
      }
    });

    ref.onDispose(() => _subscription?.cancel());
  }

  /// Force refresh the auth state.
  void refresh() {
    final authRepo = ref.read(authRepositoryProvider);
    final currentUser = authRepo.currentUser;
    if (currentUser != null) {
      state = AppAuthState.authenticated(currentUser);
    } else {
      state = const AppAuthState.unauthenticated();
    }
  }
}
