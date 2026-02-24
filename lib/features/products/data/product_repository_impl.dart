import 'package:fashion_flow/core/error/failures.dart';
import 'package:fashion_flow/features/products/domain/product.dart';
import 'package:fashion_flow/features/products/domain/product_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase implementation of [ProductRepository].
class ProductRepositoryImpl implements ProductRepository {
  final SupabaseClient _supabaseClient;

  ProductRepositoryImpl(this._supabaseClient);

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final response = await _supabaseClient
          .from('products')
          .select()
          .order('created_at', ascending: false);

      final products = (response as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(products);
    } on PostgrestException catch (e) {
      return left(
        ServerFailure(message: e.message, code: int.tryParse(e.code ?? '')),
      );
    } catch (e) {
      return left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    try {
      final response = await _supabaseClient
          .from('products')
          .select()
          .eq('id', id)
          .single();

      return right(Product.fromJson(response));
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        return left(
          const ServerFailure(message: 'Product not found', code: 404),
        );
      }
      return left(
        ServerFailure(message: e.message, code: int.tryParse(e.code ?? '')),
      );
    } catch (e) {
      return left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      final response = await _supabaseClient
          .from('products')
          .select()
          .ilike('name', '%$query%');

      final products = (response as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(products);
    } on PostgrestException catch (e) {
      return left(
        ServerFailure(message: e.message, code: int.tryParse(e.code ?? '')),
      );
    } catch (e) {
      return left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String category,
  ) async {
    try {
      final response = await _supabaseClient
          .from('products')
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);

      final products = (response as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
      return right(products);
    } on PostgrestException catch (e) {
      return left(
        ServerFailure(message: e.message, code: int.tryParse(e.code ?? '')),
      );
    } catch (e) {
      return left(UnknownFailure(message: e.toString()));
    }
  }
}
