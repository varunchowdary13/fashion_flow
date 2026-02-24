import 'package:equatable/equatable.dart';

/// Order status enum.
enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled;

  String get displayName {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  static OrderStatus fromString(String status) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == status.toLowerCase(),
      orElse: () => OrderStatus.pending,
    );
  }
}

/// Represents an item in an order.
class OrderItem extends Equatable {
  final int productId;
  final String productName;
  final String productImageUrl;
  final int quantity;
  final double priceAtPurchase;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.quantity,
    required this.priceAtPurchase,
  });

  double get subtotal => priceAtPurchase * quantity;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'] as int,
      productName: json['product_name'] as String? ?? 'Unknown Product',
      productImageUrl: json['product_image_url'] as String? ?? '',
      quantity: json['quantity'] as int,
      priceAtPurchase: (json['price_at_purchase'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_image_url': productImageUrl,
      'quantity': quantity,
      'price_at_purchase': priceAtPurchase,
    };
  }

  @override
  List<Object?> get props => [
    productId,
    productName,
    productImageUrl,
    quantity,
    priceAtPurchase,
  ];
}

/// Represents a customer order.
class Order extends Equatable {
  final String id;
  final String userId;
  final String orderNumber;
  final List<OrderItem> items;
  final double totalPrice;
  final OrderStatus status;
  final String? shippingAddress;
  final String? paymentMethod;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Order({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.items,
    required this.totalPrice,
    required this.status,
    this.shippingAddress,
    this.paymentMethod,
    required this.createdAt,
    this.updatedAt,
  });

  /// Get subtotal before tax.
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.subtotal);

  /// Get tax amount (10%).
  double get tax => subtotal * 0.10;

  /// Get total item count.
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  factory Order.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];

    return Order(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      orderNumber: json['order_number'] as String,
      items: itemsList
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['total_price'] as num).toDouble(),
      status: OrderStatus.fromString(json['status'] as String? ?? 'pending'),
      shippingAddress: json['shipping_address'] as String?,
      paymentMethod: json['payment_method'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'order_number': orderNumber,
      'items': items.map((item) => item.toJson()).toList(),
      'total_price': totalPrice,
      'status': status.name,
      'shipping_address': shippingAddress,
      'payment_method': paymentMethod,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Order copyWith({
    String? id,
    String? userId,
    String? orderNumber,
    List<OrderItem>? items,
    double? totalPrice,
    OrderStatus? status,
    String? shippingAddress,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orderNumber: orderNumber ?? this.orderNumber,
      items: items ?? this.items,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    orderNumber,
    items,
    totalPrice,
    status,
    shippingAddress,
    paymentMethod,
    createdAt,
    updatedAt,
  ];
}
