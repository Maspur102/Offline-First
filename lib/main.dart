import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'core/routing/app_router.dart';
import 'core/config/env_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const FinalProjectApp());
}

class FinalProjectApp extends StatelessWidget {
  const FinalProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seedColor = EnvConfig.isProduction ? const Color(0xFF0D47A1) : Colors.blue;
    // PERBAIKAN: Memaksa warna latar belakang aplikasi
    final scaffoldColor = EnvConfig.isProduction ? const Color(0xFF07132B) : null; 

    return MaterialApp.router(
      debugShowCheckedModeBanner: !EnvConfig.isProduction,
      title: 'DigiNews',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seedColor,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: scaffoldColor, 
        appBarTheme: AppBarTheme(
          backgroundColor: seedColor,
          foregroundColor: Colors.white,
        ),
      ),
      routerConfig: AppRouter.router,
    );
  }
}