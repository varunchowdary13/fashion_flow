import 'package:fashion_flow/features/cart/domain/cart_item.dart';
import 'package:fashion_flow/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  // Add Item (or increase quantity if exists)
  void addItem(Product product) {
    if (state.any((item) => item.product.id == product.id)) {
      state = [
        for (final item in state)
          if (item.product.id == product.id)
            item.copyWith(quantity: item.quantity + 1)
          else
            item,
      ];
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  // Remove Item (decrease quantity or remove)
  void removeItem(Product product) {
    state = [
      for (final item in state)
        if (item.product.id == product.id)
          if (item.quantity > 1)
            item.copyWith(quantity: item.quantity - 1)
          else
            // Skip this item (remove it)
            ...[]
        else
          item,
    ];
  }

  // Clear Cart
  void clearCart() {
    state = [];
  }

  // Get Total Price (Helper)
  double get totalAmount {
    return state.fold(0, (sum, item) => sum + item.totalPrice);
  }
}

// The Provider
final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});
