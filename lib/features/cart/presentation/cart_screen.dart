import 'package:fashion_flow/core/providers.dart';
import 'package:fashion_flow/core/router.dart';
import 'package:fashion_flow/features/cart/presentation/cart_controller.dart';
import 'package:fashion_flow/features/cart/presentation/cart_item_tile.dart';
import 'package:fashion_flow/features/orders/domain/order.dart' as order_domain;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Tax rate for cart calculations.
const double _taxRate = 0.10; // 10%

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cartItems = ref.watch(cartProvider);
    final subtotal = ref.watch(cartTotalProvider);
    final tax = subtotal * _taxRate;
    final total = subtotal + tax;
    final itemCount = ref.watch(cartItemCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        centerTitle: true,
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear cart',
              onPressed: () => _showClearCartDialog(context, ref),
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? _EmptyCartView(onContinueShopping: () => context.pop())
          : Column(
              children: [
                // Item count header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  child: Text(
                    '$itemCount ${itemCount == 1 ? 'item' : 'items'} in cart',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),

                // Cart items list
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return CartItemTile(
                        key: ValueKey(item.product.id),
                        item: item,
                        onRemove: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${item.product.name} removed from cart',
                              ),
                              action: SnackBarAction(
                                label: 'Undo',
                                onPressed: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .addItem(
                                        item.product,
                                        quantity: item.quantity,
                                      );
                                },
                              ),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Order summary & checkout
                _OrderSummary(
                  subtotal: subtotal,
                  tax: tax,
                  total: total,
                  onCheckout: () => _handleCheckout(context, ref, total),
                  onContinueShopping: () => context.pop(),
                ),
              ],
            ),
    );
  }

  void _showClearCartDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(cartProvider.notifier).clearCart();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Cart cleared')));
            },
            child: Text(
              'Clear',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCheckout(BuildContext context, WidgetRef ref, double total) {
    final cartItems = ref.read(cartProvider);
    final subtotal = ref.read(cartTotalProvider);
    final tax = subtotal * _taxRate;
    final supabase = ref.read(supabaseClientProvider);
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to checkout')),
      );
      return;
    }

    // Convert cart items to order items
    final orderItems = cartItems
        .map(
          (item) => order_domain.OrderItem(
            productId: item.product.id,
            productName: item.product.name,
            productImageUrl: item.product.imageUrl,
            priceAtPurchase: item.product.price,
            quantity: item.quantity,
          ),
        )
        .toList();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Create order in Supabase
    ref
        .read(orderRepositoryProvider)
        .createOrder(
          userId: userId,
          items: orderItems,
          totalPrice: subtotal + tax,
          shippingAddress: '123 Main St, City, Country', // Mock address
          paymentMethod: 'Credit Card', // Mock payment
        )
        .then((result) {
          Navigator.pop(context); // Remove loading dialog

          result.fold(
            (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to place order: ${failure.message}'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            },
            (order) {
              // Show success dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => _CheckoutSuccessDialog(
                  total: total,
                  orderNumber: order.orderNumber,
                  orderId: order.id,
                  onClose: () {
                    Navigator.pop(context);
                    ref.read(cartProvider.notifier).clearCart();
                    // Invalidate orders to refetch
                    ref.invalidate(ordersProvider);
                    context.pop();
                  },
                  onViewOrder: () {
                    Navigator.pop(context);
                    ref.read(cartProvider.notifier).clearCart();
                    // Invalidate orders to refetch
                    ref.invalidate(ordersProvider);
                    context.go(
                      AppRoutes.orderDetail.replaceFirst(':id', order.id),
                    );
                  },
                ),
              );
            },
          );
        });
  }
}

class _EmptyCartView extends StatelessWidget {
  final VoidCallback onContinueShopping;

  const _EmptyCartView({required this.onContinueShopping});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Looks like you haven\'t added\nanything to your cart yet',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onContinueShopping,
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Start Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double total;
  final VoidCallback onCheckout;
  final VoidCallback onContinueShopping;

  const _OrderSummary({
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.onCheckout,
    required this.onContinueShopping,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Order summary rows
            _SummaryRow(
              label: 'Subtotal',
              value: subtotal,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              label: 'Tax (10%)',
              value: tax,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(),
            ),
            _SummaryRow(
              label: 'Total',
              value: total,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              valueStyle: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),

            // Checkout button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: onCheckout,
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Continue shopping button
            TextButton(
              onPressed: onContinueShopping,
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final TextStyle? style;
  final TextStyle? valueStyle;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.style,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text('\$${value.toStringAsFixed(2)}', style: valueStyle ?? style),
      ],
    );
  }
}

class _CheckoutSuccessDialog extends StatelessWidget {
  final double total;
  final String orderNumber;
  final String orderId;
  final VoidCallback onClose;
  final VoidCallback onViewOrder;

  const _CheckoutSuccessDialog({
    required this.total,
    required this.orderNumber,
    required this.orderId,
    required this.onClose,
    required this.onViewOrder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 64,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Order Placed!',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order has been placed successfully',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Order #$orderNumber',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onViewOrder,
                child: const Text('View Order'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onClose,
                child: const Text('Continue Shopping'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
