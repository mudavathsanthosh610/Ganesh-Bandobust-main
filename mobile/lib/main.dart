import 'package:flutter/material.dart';
import 'screens/login/login_screen.dart';

void main() {
  runApp(const GaneshBandobustApp());
}

class GaneshBandobustApp extends StatelessWidget {
  const GaneshBandobustApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ganesh Bandobust',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF17365D),
        ),

        scaffoldBackgroundColor: const Color(0xFFF1F5F9),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF17365D),
          foregroundColor: Colors.white,
        ),
      ),

      home: const LoginScreen(),
    );
  }
}