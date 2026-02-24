import 'package:fashion_flow/features/products/domain/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Product', () {
    test('should create Product from JSON', () {
      final json = {
        'id': 1,
        'name': 'Test Product',
        'description': 'A test product description',
        'price': 29.99,
        'image_url': 'https://example.com/image.jpg',
        'category': 'Tops',
        'in_stock': true,
        'created_at': '2024-01-01T00:00:00Z',
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.name, 'Test Product');
      expect(product.description, 'A test product description');
      expect(product.price, 29.99);
      expect(product.imageUrl, 'https://example.com/image.jpg');
      expect(product.category, 'Tops');
      expect(product.inStock, true);
    });

    test('should handle null inStock in JSON (default to true)', () {
      final json = {
        'id': 1,
        'name': 'Test Product',
        'description': 'A test product',
        'price': 19.99,
        'image_url': 'https://example.com/image.jpg',
        'category': 'Dresses',
        'in_stock': null,
        'created_at': '2024-01-01T00:00:00Z',
      };

      final product = Product.fromJson(json);

      expect(product.inStock, true);
    });

    test('should convert Product to JSON', () {
      final product = Product(
        id: 1,
        name: 'Test Product',
        description: 'A test product',
        price: 29.99,
        imageUrl: 'https://example.com/image.jpg',
        category: 'Tops',
        inStock: true,
        createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
      );

      final json = product.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Test Product');
      expect(json['price'], 29.99);
      expect(json['category'], 'Tops');
    });

    test('copyWith should create new instance with updated fields', () {
      final product = Product(
        id: 1,
        name: 'Original',
        description: 'Original description',
        price: 29.99,
        imageUrl: 'https://example.com/image.jpg',
        category: 'Tops',
        inStock: true,
        createdAt: DateTime.now(),
      );

      final updated = product.copyWith(name: 'Updated', price: 39.99);

      expect(updated.name, 'Updated');
      expect(updated.price, 39.99);
      expect(updated.id, product.id);
      expect(updated.description, product.description);
    });

    test('two products with same properties should be equal', () {
      final createdAt = DateTime.parse('2024-01-01T00:00:00Z');

      final product1 = Product(
        id: 1,
        name: 'Test',
        description: 'Test description',
        price: 29.99,
        imageUrl: 'https://example.com/image.jpg',
        category: 'Tops',
        inStock: true,
        createdAt: createdAt,
      );

      final product2 = Product(
        id: 1,
        name: 'Test',
        description: 'Test description',
        price: 29.99,
        imageUrl: 'https://example.com/image.jpg',
        category: 'Tops',
        inStock: true,
        createdAt: createdAt,
      );

      expect(product1, equals(product2));
    });
  });
}
