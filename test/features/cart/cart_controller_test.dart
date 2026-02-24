import 'package:fashion_flow/features/cart/presentation/cart_controller.dart';
import 'package:fashion_flow/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  final testProduct1 = Product(
    id: 1,
    name: 'Test Product 1',
    description: 'Description 1',
    price: 29.99,
    imageUrl: 'https://example.com/1.jpg',
    category: 'Tops',
    inStock: true,
    createdAt: DateTime.now(),
  );

  final testProduct2 = Product(
    id: 2,
    name: 'Test Product 2',
    description: 'Description 2',
    price: 49.99,
    imageUrl: 'https://example.com/2.jpg',
    category: 'Dresses',
    inStock: true,
    createdAt: DateTime.now(),
  );

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('CartNotifier', () {
    test('should start with empty cart', () {
      final cart = container.read(cartProvider);
      expect(cart, isEmpty);
    });

    test('should add item to cart', () {
      container.read(cartProvider.notifier).addItem(testProduct1);

      final cart = container.read(cartProvider);
      expect(cart.length, 1);
      expect(cart.first.product.id, testProduct1.id);
      expect(cart.first.quantity, 1);
    });

    test('should add item with custom quantity', () {
      container.read(cartProvider.notifier).addItem(testProduct1, quantity: 3);

      final cart = container.read(cartProvider);
      expect(cart.first.quantity, 3);
    });

    test('should increase quantity when adding existing product', () {
      container.read(cartProvider.notifier).addItem(testProduct1);
      container.read(cartProvider.notifier).addItem(testProduct1);

      final cart = container.read(cartProvider);
      expect(cart.length, 1);
      expect(cart.first.quantity, 2);
    });

    test('should add multiple different products', () {
      container.read(cartProvider.notifier).addItem(testProduct1);
      container.read(cartProvider.notifier).addItem(testProduct2);

      final cart = container.read(cartProvider);
      expect(cart.length, 2);
    });

    test('should decrease quantity', () {
      container.read(cartProvider.notifier).addItem(testProduct1, quantity: 3);
      container.read(cartProvider.notifier).decreaseQuantity(testProduct1);

      final cart = container.read(cartProvider);
      expect(cart.first.quantity, 2);
    });

    test('should remove item when quantity reaches 0', () {
      container.read(cartProvider.notifier).addItem(testProduct1);
      container.read(cartProvider.notifier).decreaseQuantity(testProduct1);

      final cart = container.read(cartProvider);
      expect(cart, isEmpty);
    });

    test('should update quantity to specific value', () {
      container.read(cartProvider.notifier).addItem(testProduct1);
      container.read(cartProvider.notifier).updateQuantity(testProduct1.id, 5);

      final cart = container.read(cartProvider);
      expect(cart.first.quantity, 5);
    });

    test('should remove item when updating quantity to 0', () {
      container.read(cartProvider.notifier).addItem(testProduct1);
      container.read(cartProvider.notifier).updateQuantity(testProduct1.id, 0);

      final cart = container.read(cartProvider);
      expect(cart, isEmpty);
    });

    test('should remove item', () {
      container.read(cartProvider.notifier).addItem(testProduct1);
      container.read(cartProvider.notifier).addItem(testProduct2);
      container.read(cartProvider.notifier).removeItem(testProduct1.id);

      final cart = container.read(cartProvider);
      expect(cart.length, 1);
      expect(cart.first.product.id, testProduct2.id);
    });

    test('should clear cart', () {
      container.read(cartProvider.notifier).addItem(testProduct1);
      container.read(cartProvider.notifier).addItem(testProduct2);
      container.read(cartProvider.notifier).clearCart();

      final cart = container.read(cartProvider);
      expect(cart, isEmpty);
    });

    test('should check if product is in cart', () {
      container.read(cartProvider.notifier).addItem(testProduct1);

      expect(
        container.read(cartProvider.notifier).isInCart(testProduct1.id),
        isTrue,
      );
      expect(
        container.read(cartProvider.notifier).isInCart(testProduct2.id),
        isFalse,
      );
    });

    test('should get quantity of product in cart', () {
      container.read(cartProvider.notifier).addItem(testProduct1, quantity: 3);

      expect(
        container.read(cartProvider.notifier).getQuantity(testProduct1.id),
        3,
      );
      expect(
        container.read(cartProvider.notifier).getQuantity(testProduct2.id),
        0,
      );
    });
  });

  group('Cart Providers', () {
    test('cartTotalProvider should calculate total', () {
      container.read(cartProvider.notifier).addItem(testProduct1, quantity: 2);
      container.read(cartProvider.notifier).addItem(testProduct2, quantity: 1);

      final total = container.read(cartTotalProvider);
      // 2 * 29.99 + 1 * 49.99 = 59.98 + 49.99 = 109.97
      expect(total, closeTo(109.97, 0.01));
    });

    test('cartItemCountProvider should count total items', () {
      container.read(cartProvider.notifier).addItem(testProduct1, quantity: 2);
      container.read(cartProvider.notifier).addItem(testProduct2, quantity: 3);

      final count = container.read(cartItemCountProvider);
      expect(count, 5);
    });
  });
}
