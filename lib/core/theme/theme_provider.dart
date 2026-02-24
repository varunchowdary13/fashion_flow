import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Key used to persist theme mode in SharedPreferences.
const String _themeModeKey = 'theme_mode';

/// Provider for SharedPreferences instance.
/// Must be overridden in ProviderScope with an async value.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized before use');
});

/// Provider for the current theme mode.
///
/// Persists the user's theme preference to SharedPreferences.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

/// Notifier that manages theme mode state and persistence.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return _loadInitialTheme(prefs);
  }

  /// Loads the initial theme from SharedPreferences.
  ThemeMode _loadInitialTheme(SharedPreferences prefs) {
    final themeIndex = prefs.getInt(_themeModeKey);
    if (themeIndex == null) return ThemeMode.system;
    return ThemeMode.values[themeIndex];
  }

  /// Sets the theme mode and persists it.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_themeModeKey, mode.index);
  }

  /// Toggles between light and dark theme.
  /// If currently system, switches to light.
  Future<void> toggleTheme() async {
    final newMode = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.light,
    };
    await setThemeMode(newMode);
  }

  /// Returns true if current theme is dark.
  bool get isDarkMode => state == ThemeMode.dark;
}
