import 'package:fashion_flow/features/cart/domain/cart_item.dart';
import 'package:fashion_flow/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  /// Add item to cart with optional quantity (defaults to 1).
  /// If product already in cart, increases quantity.
  void addItem(Product product, {int quantity = 1}) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      // Product exists - increase quantity
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingIndex)
            state[i].copyWith(quantity: state[i].quantity + quantity)
          else
            state[i],
      ];
    } else {
      // New product - add to cart
      state = [...state, CartItem(product: product, quantity: quantity)];
    }
  }

  /// Decrease quantity by 1. Removes item if quantity reaches 0.
  void decreaseQuantity(Product product) {
    state = [
      for (final item in state)
        if (item.product.id == product.id)
          if (item.quantity > 1)
            item.copyWith(quantity: item.quantity - 1)
          else
            ...<CartItem>[] // Remove item when quantity is 0
        else
          item,
    ];
  }

  /// Update quantity to specific value. Removes if quantity <= 0.
  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    state = [
      for (final item in state)
        if (item.product.id == productId)
          item.copyWith(quantity: quantity)
        else
          item,
    ];
  }

  /// Remove item completely from cart.
  void removeItem(int productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  /// Clear all items from cart.
  void clearCart() {
    state = [];
  }

  /// Get total price of all items.
  double get totalAmount {
    return state.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Get total item count in cart.
  int get itemCount {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Check if product is in cart.
  bool isInCart(int productId) {
    return state.any((item) => item.product.id == productId);
  }

  /// Get quantity of specific product in cart.
  int getQuantity(int productId) {
    final item = state
        .where((item) => item.product.id == productId)
        .firstOrNull;
    return item?.quantity ?? 0;
  }
}

/// Cart provider.
final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});

/// Derived provider for total amount (convenience).
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0.0, (sum, item) => sum + item.totalPrice);
});

/// Derived provider for item count badge.
final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
});
