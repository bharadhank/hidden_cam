import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService().init();
  runApp(const SafeLensApp());
}

class SafeLensApp extends StatelessWidget {
  const SafeLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafeLens',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
