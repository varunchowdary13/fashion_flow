import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<Either<String, AuthResponse>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<String, AuthResponse>> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  Future<void> signOut();

  User? get currentUser;
}
