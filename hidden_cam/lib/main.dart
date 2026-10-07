import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SafeLensApp());
}

class SafeLensApp extends StatelessWidget {
  const SafeLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafeLens',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F3E8), // Warm Cream
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA8C3A0), // Soft Sage Green
          primary: const Color(0xFFA8C3A0),
          secondary: const Color(0xFF4F8F89), // Natural Teal
          onPrimary: const Color(0xFF23483F), // Deep Forest Green
          onSurface: const Color(0xFF23483F),
          error: const Color(0xFFD6A84F), // Caution Amber
        ),
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F3E8),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF23483F)),
          titleTextStyle: TextStyle(
            color: Color(0xFF23483F),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),



      ),
      home: const HomeScreen(),
    );
  }
}
