import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeForge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA87C7C), // Soft Red
          primary: const Color(0xFFA87C7C),
          secondary: const Color(0xFF7E6363), // Muted Red
          surface: const Color(0xFFF9F5F2), // Cream
          onSurface: const Color(0xFF3E3232), // Dark Brown
          outline: const Color(0xFF503C3C), // Deep Brown
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F5F2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF3E3232),
          foregroundColor: Colors.white,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          shadowColor: Color(0xFF503C3C),
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFA87C7C),
            foregroundColor: Colors.white,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF7E6363),
            side: const BorderSide(color: Color(0xFF7E6363)),
          ),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}