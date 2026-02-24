import 'package:fashion_flow/features/products/domain/product.dart';
import 'package:fpdart/fpdart.dart';
import 'package:fashion_flow/core/error/failures.dart';

/// Abstract repository interface for product operations.
/// Implementations should handle data fetching from remote/local sources.
abstract class ProductRepository {
  /// Fetches all products, ordered by creation date (newest first).
  Future<Either<Failure, List<Product>>> getProducts();

  /// Fetches a single product by its ID.
  Future<Either<Failure, Product>> getProductById(int id);

  /// Searches products by name (case-insensitive).
  Future<Either<Failure, List<Product>>> searchProducts(String query);

  /// Fetches products filtered by category.
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);
}
