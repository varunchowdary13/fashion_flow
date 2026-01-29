import 'package:fashion_flow/core/theme/app_theme.dart';
import 'package:fashion_flow/features/auth/presentation/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rksihpiooylsavibbunt.supabase.co',
    anonKey: 'sb_publishable_KV1PH1A00VCJvSr74_Z8JA_oC-tbgAs',
  );

  runApp(const ProviderScope(child: FashionFlowApp()));
}

class FashionFlowApp extends StatelessWidget {
  const FashionFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fashion Flow',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
