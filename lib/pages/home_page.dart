import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Текстовые контроллеры для каждого поля
  final nameController = TextEditingController();
  final imageUrlController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  /* 
  CREATE - создание новой записи и сохранение в Supabase
  */

  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить новую запись'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              // Поля ввода данных
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
            ],
          ),
        ),
        actions: [
          // Кнопка для сохранения
          TextButton(
            onPressed: () {
              saveNote();
              Navigator.pop(context);
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void saveNote() async {
    // Преобразование строки с ценой в число
    final double? price = double.tryParse(priceController.text);

    // Сохранение данных в таблице 'notes' в Supabase
    await Supabase.instance.client
        .from('notes')
        .insert({
          'Name': nameController.text, // Поле Name
          'ImageURL': imageUrlController.text, // Поле ImageURL
          'Description': descriptionController.text, // Поле Description
          'Price': price, // Поле Price (как число)
        });

    // Очищаем поля после сохранения
    nameController.clear();
    imageUrlController.clear();
    descriptionController.clear();
    priceController.clear();
  }

  /* 
  READ - данные из таблицы Supabase
  */

  final _notesStream = Supabase.instance.client.from('notes').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Видеоигры'),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF67BEEA),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _notesStream,
        builder: (context, snapshot) {
          // Показ индикатора загрузки
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Загруженные данные
          final notes = snapshot.data;

          // Если данных нет
          if (notes == null || notes.isEmpty) {
            return const Center(child: Text('Нет товаров'));
          }

          // Отображение сетки с товарами
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Количество колонок
              childAspectRatio: 0.6, // Пропорции элементов
              crossAxisSpacing: 16.0, // Расстояние между колонками
              mainAxisSpacing: 16.0, // Расстояние между строками
            ),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];

              // Извлекаем данные для отображения
              final name = note['Name'] ?? 'Без названия';
              final imageUrl = note['ImageURL'] ?? '';
              final description = note['Description'] ?? 'Нет описания';
              final price = note['Price'] != null ? '\Р${note['Price']}' : 'Цена не указана';

              // Отображаем карточку товара
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Отображаем изображение товара, если оно указано
                      if (imageUrl.isNotEmpty)
                        Expanded(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      const SizedBox(height: 8),
                      // Отображаем название товара
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Отображаем описание
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Отображаем цену товара
                      Text(
                        price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
