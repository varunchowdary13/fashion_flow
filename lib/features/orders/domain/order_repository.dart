import 'package:fashion_flow/core/error/failures.dart';
import 'package:fashion_flow/features/orders/domain/order.dart';
import 'package:fpdart/fpdart.dart' hide Order;

/// Abstract repository for Order operations.
abstract class OrderRepository {
  /// Fetch order history for a user.
  Future<Either<Failure, List<Order>>> getOrders(String userId);

  /// Fetch a single order by ID.
  Future<Either<Failure, Order>> getOrderById(String orderId);

  /// Create a new order.
  Future<Either<Failure, Order>> createOrder({
    required String userId,
    required List<OrderItem> items,
    required double totalPrice,
    required String shippingAddress,
    required String paymentMethod,
  });

  /// Update order status (admin only in production).
  Future<Either<Failure, Order>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  );
}
