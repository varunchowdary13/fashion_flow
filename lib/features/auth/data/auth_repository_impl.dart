import 'package:fashion_flow/core/error/failures.dart';
import 'package:fashion_flow/features/auth/domain/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase implementation of [AuthRepository].
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepositoryImpl(this._supabaseClient);

  @override
  User? get currentUser => _supabaseClient.auth.currentUser;

  @override
  bool get isAuthenticated => currentUser != null;

  @override
  Stream<AuthState> get authStateChanges =>
      _supabaseClient.auth.onAuthStateChange;

  @override
  Future<Either<Failure, AuthResponse>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return right(response);
    } on AuthException catch (e) {
      return left(AuthFailure(message: e.message));
    } catch (e) {
      return left(ServerFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      return right(response);
    } on AuthException catch (e) {
      return left(AuthFailure(message: e.message));
    } catch (e) {
      return left(ServerFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
      return right(unit);
    } on AuthException catch (e) {
      return left(AuthFailure(message: e.message));
    } catch (e) {
      return left(ServerFailure(message: 'Failed to sign out: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({required String email}) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
      return right(unit);
    } on AuthException catch (e) {
      return left(AuthFailure(message: e.message));
    } catch (e) {
      return left(ServerFailure(message: 'Failed to send reset email: $e'));
    }
  }
}
