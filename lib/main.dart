import 'package:fashion_flow/core/router.dart';
import 'package:fashion_flow/core/theme/app_theme.dart';
import 'package:fashion_flow/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences for theme persistence
  final prefs = await SharedPreferences.getInstance();

  // TODO: Move credentials to environment variables for security
  await Supabase.initialize(
    url: 'https://rksihpiooylsavibbunt.supabase.co',
    anonKey: 'sb_publishable_KV1PH1A00VCJvSr74_Z8JA_oC-tbgAs',
  );

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const FashionFlowApp(),
    ),
  );
}

class FashionFlowApp extends ConsumerWidget {
  const FashionFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = createRouter();
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Fashion Flow',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
