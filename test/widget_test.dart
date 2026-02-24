// Basic Flutter widget test for Fashion Flow app.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fashion_flow/main.dart';
import 'package:fashion_flow/core/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    // Initialize SharedPreferences for testing
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app and trigger a frame with mocked preferences.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const FashionFlowApp(),
      ),
    );

    // Verify the app builds and shows login screen
    await tester.pumpAndSettle();

    // Basic smoke test - app should render without throwing
    expect(tester.takeException(), isNull);
  });
}
