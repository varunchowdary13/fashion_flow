import 'package:fashion_flow/features/auth/domain/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepositoryImpl(this._supabaseClient);

  @override
  User? get currentUser => _supabaseClient.auth.currentUser;

  @override
  Future<Either<String, AuthResponse>> loginWithEmailPassword({
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
      return left(e.message);
    } catch (e) {
      return left('An unexpected error occurred: $e');
    }
  }

  @override
  Future<Either<String, AuthResponse>> signUp({
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
      return left(e.message);
    } catch (e) {
      return left('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }
}
