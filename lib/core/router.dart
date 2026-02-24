import 'package:fashion_flow/features/auth/presentation/login_screen.dart';
import 'package:fashion_flow/features/auth/presentation/signup_screen.dart';
import 'package:fashion_flow/features/cart/presentation/cart_screen.dart';
import 'package:fashion_flow/features/orders/presentation/order_detail_screen.dart';
import 'package:fashion_flow/features/orders/presentation/orders_screen.dart';
import 'package:fashion_flow/features/products/presentation/home_screen.dart';
import 'package:fashion_flow/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Application route paths.
abstract class AppRoutes {
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/';
  static const cart = '/cart';
  static const productDetail = '/product/:id';
  static const profile = '/profile';
  static const orders = '/orders';
  static const orderDetail = '/orders/:id';
}

/// Creates the GoRouter instance for the app.
/// Handles authentication redirects automatically.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final isAuthRoute =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup;

      // If not logged in and not on auth page, redirect to login
      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.login;
      }

      // If logged in and on auth page, redirect to home
      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.home;
      }

      // No redirect needed
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      // Main routes
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.cart,
        name: 'cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.orders,
        name: 'orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderDetail,
        name: 'orderDetail',
        builder: (context, state) {
          final orderId = state.pathParameters['id']!;
          return OrderDetailScreen(orderId: orderId);
        },
      ),
      // TODO: Add product detail route in Stage 3
      // GoRoute(
      //   path: AppRoutes.productDetail,
      //   name: 'productDetail',
      //   builder: (context, state) {
      //     final productId = int.parse(state.pathParameters['id']!);
      //     return ProductDetailScreen(productId: productId);
      //   },
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Route: ${state.matchedLocation}'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
