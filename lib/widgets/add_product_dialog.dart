import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  _AddProductDialogState createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final nameController = TextEditingController();
  final imageUrlController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final genreController = TextEditingController(); // Для жанра
  final releaseDateController = TextEditingController(); // Для даты выпуска
  final developerController = TextEditingController(); // Для разработчика

  void saveNote() async {
    final double? price = double.tryParse(priceController.text);
    final DateTime? releaseDate = DateTime.tryParse(releaseDateController.text); // Преобразование даты

    await Supabase.instance.client.from('notes').insert({
      'Name': nameController.text,
      'ImageURL': imageUrlController.text,
      'Description': descriptionController.text,
      'Price': price,
      'Genre': genreController.text, // Добавление жанра
      'ReleaseDate': releaseDate?.toIso8601String(), // Добавление даты выпуска
      'Developer': developerController.text, // Добавление разработчика
    });

    // Очищаем поля после сохранения
    nameController.clear();
    imageUrlController.clear();
    descriptionController.clear();
    priceController.clear();
    genreController.clear();
    releaseDateController.clear();
    developerController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить новую запись'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Название'),
            ),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(labelText: 'URL изображения'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Описание'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Цена'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: genreController,
              decoration: const InputDecoration(labelText: 'Жанр'), // Поле для жанра
            ),
            TextField(
              controller: releaseDateController,
              decoration: const InputDecoration(labelText: 'Дата выпуска (гггг-мм-дд)'), // Поле для даты выпуска
            ),
            TextField(
              controller: developerController,
              decoration: const InputDecoration(labelText: 'Разработчик'), // Поле для разработчика
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            saveNote();
            Navigator.pop(context);
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
