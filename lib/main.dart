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
    // Logika Warna Utama Anti-AI
    // Jika PROD, gunakan Biru Gelap. Jika DEV, gunakan warna standar.
    final seedColor = EnvConfig.isProduction ? const Color(0xFF0D47A1) : Colors.blue;

    return MaterialApp.router(
      debugShowCheckedModeBanner: !EnvConfig.isProduction,
      // Mengubah internal title aplikasi
      title: EnvConfig.isProduction ? 'UTD - 20123011' : 'DEV - Purnama',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seedColor,
        brightness: Brightness.dark,
      ),
      routerConfig: AppRouter.router,
    );
  }
}