import 'package:flutter/material.dart';
import 'package:pcs_11/auth/auth_service.dart';
import 'package:pcs_11/pages/main_profile/profile_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final authServices = AuthServices();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void signUp() async {

    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Пароли не совпадают"))
      );
      return;
    }

    try {
      await authServices.signUpWithEmailPassword(email, password);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      }
    } 

    catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ошибка: $e"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Регистрация"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Почта"),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: "Пароль"),
            obscureText: true,
          ),

          TextField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(labelText: "Повторите пароль"),
            obscureText: true,
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: signUp,
            child: const Text("Зарегистрироваться"),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
