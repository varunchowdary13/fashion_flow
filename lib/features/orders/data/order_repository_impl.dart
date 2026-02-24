import 'dart:math';

import 'package:fashion_flow/core/error/failures.dart';
import 'package:fashion_flow/features/orders/domain/order.dart';
import 'package:fashion_flow/features/orders/domain/order_repository.dart';
import 'package:fpdart/fpdart.dart' hide Order;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase implementation of [OrderRepository].
class OrderRepositoryImpl implements OrderRepository {
  final SupabaseClient _supabaseClient;

  OrderRepositoryImpl(this._supabaseClient);

  /// Generate a unique order number.
  String _generateOrderNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = Random().nextInt(9999).toString().padLeft(4, '0');
    return 'FF-$timestamp$random';
  }

  @override
  Future<Either<Failure, List<Order>>> getOrders(String userId) async {
    try {
      final response = await _supabaseClient
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final orders = (response as List)
          .map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList();

      return right(orders);
    } on PostgrestException catch (e) {
      return left(
        ServerFailure(message: e.message, code: int.tryParse(e.code ?? '')),
      );
    } catch (e) {
      return left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderById(String orderId) async {
    try {
      final response = await _supabaseClient
          .from('orders')
          .select()
          .eq('id', orderId)
          .single();

      return right(Order.fromJson(response));
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        return left(const ServerFailure(message: 'Order not found', code: 404));
      }
      return left(
        ServerFailure(message: e.message, code: int.tryParse(e.code ?? '')),
      );
    } catch (e) {
      return left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> createOrder({
    required String userId,
    required List<OrderItem> items,
    required double totalPrice,
    required String shippingAddress,
    required String paymentMethod,
  }) async {
    try {
      final orderNumber = _generateOrderNumber();

      final orderData = {
        'user_id': userId,
        'order_number': orderNumber,
        'items': items.map((item) => item.toJson()).toList(),
        'total_price': totalPrice,
        'status': OrderStatus.pending.name,
        'shipping_address': shippingAddress,
        'payment_method': paymentMethod,
      };

      final response = await _supabaseClient
          .from('orders')
          .insert(orderData)
          .select()
          .single();

      return right(Order.fromJson(response));
    } on PostgrestException catch (e) {
      return left(
        ServerFailure(message: e.message, code: int.tryParse(e.code ?? '')),
      );
    } catch (e) {
      return left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> updateOrderStatus(
    String orderId,
    OrderStatus status,
  ) async {
    try {
      final response = await _supabaseClient
          .from('orders')
          .update({
            'status': status.name,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId)
          .select()
          .single();

      return right(Order.fromJson(response));
    } on PostgrestException catch (e) {
      return left(
        ServerFailure(message: e.message, code: int.tryParse(e.code ?? '')),
      );
    } catch (e) {
      return left(UnknownFailure(message: e.toString()));
    }
  }
}
