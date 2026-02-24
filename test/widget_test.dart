// Basic Flutter widget tests for Fashion Flow app.
// Note: Full app integration tests require Supabase initialization.
// These tests focus on individual widgets that don't require backend.

import 'package:fashion_flow/core/theme/app_theme.dart';
import 'package:fashion_flow/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Theme Tests', () {
    testWidgets('Light theme should have correct primary color', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: Text('Test')),
        ),
      );

      final theme = Theme.of(tester.element(find.text('Test')));
      expect(theme.colorScheme.primary, AppTheme.primaryColor);
    });

    testWidgets('Dark theme should have correct primary color', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: Text('Test')),
        ),
      );

      final theme = Theme.of(tester.element(find.text('Test')));
      expect(theme.colorScheme.primary, AppTheme.primaryColor);
    });
  });

  group('Login Screen Widget Tests', () {
    testWidgets('Login screen should show email and password fields', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('Login screen should show sign in button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );

      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Login screen should show sign up link', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LoginScreen())),
      );

      expect(find.textContaining("Don't have an account"), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });
  });
}
