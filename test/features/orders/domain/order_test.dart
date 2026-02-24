import 'package:fashion_flow/features/orders/domain/order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OrderStatus', () {
    test('should return correct display name', () {
      expect(OrderStatus.pending.displayName, 'Pending');
      expect(OrderStatus.processing.displayName, 'Processing');
      expect(OrderStatus.shipped.displayName, 'Shipped');
      expect(OrderStatus.delivered.displayName, 'Delivered');
      expect(OrderStatus.cancelled.displayName, 'Cancelled');
    });

    test('fromString should parse valid status', () {
      expect(OrderStatus.fromString('pending'), OrderStatus.pending);
      expect(OrderStatus.fromString('processing'), OrderStatus.processing);
      expect(OrderStatus.fromString('shipped'), OrderStatus.shipped);
      expect(OrderStatus.fromString('delivered'), OrderStatus.delivered);
      expect(OrderStatus.fromString('cancelled'), OrderStatus.cancelled);
    });

    test('fromString should return pending for invalid status', () {
      expect(OrderStatus.fromString('invalid'), OrderStatus.pending);
      expect(OrderStatus.fromString(''), OrderStatus.pending);
    });

    test('fromString should be case insensitive', () {
      expect(OrderStatus.fromString('PENDING'), OrderStatus.pending);
      expect(OrderStatus.fromString('Processing'), OrderStatus.processing);
    });
  });

  group('OrderItem', () {
    test('should create OrderItem from JSON', () {
      final json = {
        'product_id': 1,
        'product_name': 'Test Item',
        'product_image_url': 'https://example.com/image.jpg',
        'quantity': 2,
        'price_at_purchase': 29.99,
      };

      final item = OrderItem.fromJson(json);

      expect(item.productId, 1);
      expect(item.productName, 'Test Item');
      expect(item.productImageUrl, 'https://example.com/image.jpg');
      expect(item.quantity, 2);
      expect(item.priceAtPurchase, 29.99);
    });

    test('subtotal should calculate correctly', () {
      final item = const OrderItem(
        productId: 1,
        productName: 'Test Item',
        productImageUrl: 'https://example.com/image.jpg',
        quantity: 3,
        priceAtPurchase: 10.00,
      );

      expect(item.subtotal, 30.00);
    });

    test('should convert OrderItem to JSON', () {
      const item = OrderItem(
        productId: 1,
        productName: 'Test Item',
        productImageUrl: 'https://example.com/image.jpg',
        quantity: 2,
        priceAtPurchase: 29.99,
      );

      final json = item.toJson();

      expect(json['product_id'], 1);
      expect(json['product_name'], 'Test Item');
      expect(json['quantity'], 2);
      expect(json['price_at_purchase'], 29.99);
    });

    test('two OrderItems with same properties should be equal', () {
      const item1 = OrderItem(
        productId: 1,
        productName: 'Test Item',
        productImageUrl: 'https://example.com/image.jpg',
        quantity: 2,
        priceAtPurchase: 29.99,
      );

      const item2 = OrderItem(
        productId: 1,
        productName: 'Test Item',
        productImageUrl: 'https://example.com/image.jpg',
        quantity: 2,
        priceAtPurchase: 29.99,
      );

      expect(item1, equals(item2));
    });
  });

  group('Order', () {
    test('should create Order from JSON', () {
      final json = {
        'id': 'order-123',
        'user_id': 'user-456',
        'order_number': 'FF-12345678',
        'items': [
          {
            'product_id': 1,
            'product_name': 'Item 1',
            'product_image_url': 'https://example.com/1.jpg',
            'quantity': 2,
            'price_at_purchase': 29.99,
          },
          {
            'product_id': 2,
            'product_name': 'Item 2',
            'product_image_url': 'https://example.com/2.jpg',
            'quantity': 1,
            'price_at_purchase': 49.99,
          },
        ],
        'total_price': 109.97,
        'status': 'processing',
        'shipping_address': '123 Main St',
        'payment_method': 'Credit Card',
        'created_at': '2024-01-15T10:30:00Z',
        'updated_at': '2024-01-15T12:00:00Z',
      };

      final order = Order.fromJson(json);

      expect(order.id, 'order-123');
      expect(order.userId, 'user-456');
      expect(order.orderNumber, 'FF-12345678');
      expect(order.items.length, 2);
      expect(order.totalPrice, 109.97);
      expect(order.status, OrderStatus.processing);
      expect(order.shippingAddress, '123 Main St');
      expect(order.paymentMethod, 'Credit Card');
    });

    test('subtotal should sum all item subtotals', () {
      const items = [
        OrderItem(
          productId: 1,
          productName: 'Item 1',
          productImageUrl: 'https://example.com/1.jpg',
          quantity: 2,
          priceAtPurchase: 10.00,
        ),
        OrderItem(
          productId: 2,
          productName: 'Item 2',
          productImageUrl: 'https://example.com/2.jpg',
          quantity: 3,
          priceAtPurchase: 15.00,
        ),
      ];

      final order = Order(
        id: 'order-123',
        userId: 'user-456',
        orderNumber: 'FF-12345678',
        items: items,
        totalPrice: 75.00,
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );

      // 2*10 + 3*15 = 20 + 45 = 65
      expect(order.subtotal, 65.00);
    });

    test('tax should be difference between total and subtotal', () {
      const items = [
        OrderItem(
          productId: 1,
          productName: 'Item 1',
          productImageUrl: 'https://example.com/1.jpg',
          quantity: 1,
          priceAtPurchase: 100.00,
        ),
      ];

      final order = Order(
        id: 'order-123',
        userId: 'user-456',
        orderNumber: 'FF-12345678',
        items: items,
        totalPrice: 110.00, // subtotal 100 + 10 tax
        status: OrderStatus.pending,
        createdAt: DateTime.now(),
      );

      expect(order.subtotal, 100.00);
      expect(order.tax, 10.00);
    });
  });
}
