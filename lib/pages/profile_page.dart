import 'package:flutter/material.dart';
import 'package:pcs_11/auth/auth_service.dart';
import 'package:pcs_11/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Импорт Supabase

// Класс для хранения данных пользователя
class UserData {
  static final UserData _instance = UserData._internal();

  factory UserData() {
    return _instance;
  }

  UserData._internal();

  String name = '';
  String phoneNumber = '';
  String city = '';
  String email = ''; // Добавляем поле для email

  void updateUserData(String newName, String newPhoneNumber, String newCity) {
    name = newName;
    phoneNumber = newPhoneNumber;
    city = newCity;
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthServices();
  final UserData _userData = UserData();
  final SupabaseClient _supabase = Supabase.instance.client; // Инициализация Supabase

  // Метод для получения email из Supabase
  Future<void> _fetchUserEmail() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      setState(() {
        _userData.email = user.email ?? 'Неизвестно'; // Получаем email из Supabase
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserEmail(); // Загружаем email при инициализации страницы
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Вы уверены?"),
          content: const Text("Вы действительно хотите выйти из профиля?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Нет"),
            ),
            TextButton(
              onPressed: () async {
                await authService.signOut();
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
              },
              child: const Text("Да"),
            ),
          ],
        );
      },
    );
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController(text: _userData.name);
        final TextEditingController phoneController = TextEditingController(text: _userData.phoneNumber);
        final TextEditingController cityController = TextEditingController(text: _userData.city);

        return AlertDialog(
          title: const Text('Редактировать профиль'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Имя'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Телефон'),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'Город'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Отмена'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () {
                _userData.updateUserData(
                  nameController.text,
                  phoneController.text,
                  cityController.text,
                );
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = authService.getCurrentUserEmail();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Профиль"),
        actions: [
          IconButton(
            onPressed: _showLogoutConfirmationDialog,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile/unknown.jpg'),
              ),
              const SizedBox(height: 20),
              Text(
                _userData.name.isNotEmpty ? _userData.name : "Неизвестно",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Телефон:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(width: 10),
                  Text(_userData.phoneNumber, style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Город:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(width: 10),
                  Text(_userData.city, style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Почта:', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(width: 10),
                  Text(_userData.email, style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editProfile,
                child: const Text('Редактировать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}