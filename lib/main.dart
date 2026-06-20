import 'package:flutter/material.dart';
import 'core/di/injection.dart';
import 'core/routing/app_router.dart';
import 'core/config/env_config.dart';

void main() {
  // Wajib jika menggunakan async di main
  WidgetsFlutterBinding.ensureInitialized();
  
  // Menjalankan Dependency Injection
  setupLocator();
  
  runApp(const FinalProjectApp());
}

class FinalProjectApp extends StatelessWidget {
  const FinalProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: !EnvConfig.isProduction,
      title: 'UAS Mobile Lanjut',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        // SYARAT MUTLAK UAS: NIM berakhiran angka ganjil wajib menggunakan Dark Mode
        brightness: Brightness.dark,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
