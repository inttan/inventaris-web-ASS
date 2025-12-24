import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ⬇️ IMPORT PAGE
import 'pages/login_page.dart';
import 'pages/dashboard_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ootqhacqwmljvvlczmji.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9vdHFoYWNxd21sanZ2bGN6bWppIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1MzYwMzcsImV4cCI6MjA4MjExMjAzN30.0qA8vntGPhNl8NbFhDUaG00l0_bRWARe_DpZ0Ym-5Y4',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🎨 THEME PROFESIONAL
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF7F4FF),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 2,
        ),

        cardTheme: CardThemeData(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),

      // 🔐 PAKAI AUTH GATE
      home: const AuthGate(),
    );
  }
}

/// 🔐 AUTH GATE
/// - Sudah login → Dashboard
/// - Belum login → LoginPage
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      return const DashboardLayout();
    } else {
      return const LoginPage();
    }
  }
}
