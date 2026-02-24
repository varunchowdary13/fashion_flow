import 'package:fashion_flow/features/auth/data/auth_repository_impl.dart';
import 'package:fashion_flow/features/auth/domain/auth_repository.dart';
import 'package:fashion_flow/features/products/data/product_repository_impl.dart';
import 'package:fashion_flow/features/products/domain/product.dart';
import 'package:fashion_flow/features/products/domain/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ─────────────────────────────────────────────────
// Core Providers
// ─────────────────────────────────────────────────

/// Provides the Supabase client instance.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ─────────────────────────────────────────────────
// Auth Providers
// ─────────────────────────────────────────────────

/// Provides the AuthRepository implementation.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRepositoryImpl(supabase);
});

// ─────────────────────────────────────────────────
// Product Providers
// ─────────────────────────────────────────────────

/// Provides the ProductRepository implementation.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ProductRepositoryImpl(supabase);
});

/// Fetches all products. Returns `Either<Failure, List<Product>>`.
/// Use .when() or fold() to handle success/error states.
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  final result = await repo.getProducts();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (products) => products,
  );
});
