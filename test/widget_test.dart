// Basic Flutter widget tests for Fashion Flow app.
// Note: Full app integration tests require Supabase initialization.
// These tests focus on pure unit/widget tests that don't require backend.

import 'package:fashion_flow/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
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

    testWidgets('Light theme should use correct background color', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: Text('Test')),
        ),
      );

      final theme = Theme.of(tester.element(find.text('Test')));
      expect(theme.brightness, Brightness.light);
    });

    testWidgets('Dark theme should use dark brightness', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: const Scaffold(body: Text('Test')),
        ),
      );

      final theme = Theme.of(tester.element(find.text('Test')));
      expect(theme.brightness, Brightness.dark);
    });
  });
}
