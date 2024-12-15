import 'package:flutter/material.dart';
import 'package:pcs_11/auth/auth_service.dart';
import 'package:pcs_11/pages/profile_page.dart';
import 'package:pcs_11/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authServices = AuthServices();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      await authServices.signInWithEmailPassword(email, password);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ошибка: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Вход")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _emailController, 
            decoration: const InputDecoration(labelText: "Почта"),
          ),
          TextField(
            controller: _passwordController, 
            decoration: const InputDecoration(labelText: "Пароль"), 
            obscureText: true,
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: login, 
            child: const Text("Войти"),
          ),

          const SizedBox(height: 12),

          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
            child: const Center(child: Text("Впервые здесь? Зарегистрируйтесь")),
          ),
        ],
      ),
    );
  }
}
