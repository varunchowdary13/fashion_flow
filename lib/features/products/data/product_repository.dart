import 'package:fashion_flow/features/products/domain/product.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository {
  final SupabaseClient _supabaseClient;

  ProductRepository(this._supabaseClient);

  Future<List<Product>> getProducts() async {
    final response = await _supabaseClient
        .from('products')
        .select()
        .order('created_at', ascending: false);
    
    // Supabase returns a List<dynamic>, we map it to List<Product>
    return (response as List).map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final response = await _supabaseClient
        .from('products')
        .select()
        .ilike('name', '%$query%'); // Case-insensitive search
    
    return (response as List).map((e) => Product.fromJson(e)).toList();
  }
}
