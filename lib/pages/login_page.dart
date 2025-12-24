import 'package:flutter/material.dart';
import 'dashboard_layout.dart';
import '../core/supabase_client.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();

Future<void> login() async {
  try {
    final res = await supabase.auth.signInWithPassword(
      email: email.text,
      password: password.text,
    );

    if (res.session != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardLayout()),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login gagal: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: 350,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Admin Login',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
                  TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: login, child: const Text('LOGIN')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
