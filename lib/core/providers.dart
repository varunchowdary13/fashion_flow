import 'package:fashion_flow/features/auth/data/auth_repository_impl.dart';
import 'package:fashion_flow/features/auth/domain/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fashion_flow/features/products/data/product_repository.dart';
import 'package:fashion_flow/features/products/domain/product.dart';

// Supabase Client Provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return AuthRepositoryImpl(supabase);
});

// Product Repository Provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return ProductRepository(supabase);
});

// Products Future Provider (Fetches data on load)
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProducts();
});
