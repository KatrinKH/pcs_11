import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pcs_11/components/product_card.dart';

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

  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
      ),
    );
  }

  void saveNote() async {
    final double? price = double.tryParse(priceController.text);

    await Supabase.instance.client
        .from('notes')
        .insert({
          'Name': nameController.text,
          'ImageURL': imageUrlController.text,
          'Description': descriptionController.text,
          'Price': price,
        });

    nameController.clear();
    imageUrlController.clear();
    descriptionController.clear();
    priceController.clear();
  }

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
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snapshot.data;

          if (notes == null || notes.isEmpty) {
            return const Center(child: Text('Нет товаров'));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            padding: const EdgeInsets.all(10.0),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              final name = note['Name'] ?? 'Без названия';
              final imageUrl = note['ImageURL'] ?? '';
              final description = note['Description'] ?? 'Нет описания';
              final price = note['Price'] != null ? '\Р${note['Price']}' : 'Цена не указана';

              return ProductCard(
                name: name,
                imageUrl: imageUrl,
                description: description,
                price: price,
              );
            },
          );
        },
      ),
    );
  }
}
