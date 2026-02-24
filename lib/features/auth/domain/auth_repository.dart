import 'package:fashion_flow/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Domain-layer interface for authentication operations.
///
/// All methods return [Either] with [Failure] on left for error handling.
abstract class AuthRepository {
  /// Logs in a user with email and password.
  Future<Either<Failure, AuthResponse>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  /// Registers a new user with email, password, and full name.
  Future<Either<Failure, AuthResponse>> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  /// Signs out the current user.
  Future<Either<Failure, Unit>> signOut();

  /// Returns the currently authenticated user, if any.
  User? get currentUser;

  /// Returns true if there is a currently authenticated session.
  bool get isAuthenticated;

  /// Stream of auth state changes for reactive UI updates.
  Stream<AuthState> get authStateChanges;

  /// Sends a password reset email.
  Future<Either<Failure, Unit>> resetPassword({required String email});
}
