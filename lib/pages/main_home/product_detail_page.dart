import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Отладка: вывод объекта продукта в консоль
    print(product);

    // Инициализация данных из объекта продукта
    final name = product['Name'] ?? 'Без названия';
    final imageUrl = product['ImageURL'] ?? '';
    final description = product['Description'] ?? 'Нет описания';
    final price = product['Price'] != null ? '\Р${product['Price']}' : 'Цена не указана';

    // Проверьте, что названия полей совпадают с названиями в Supabase
    final genre = product['genre'] ?? 'Жанр не указан'; // Убедитесь, что поле называется 'genre'
    final releaseDate = product['releaseDate'] ?? 'Дата выпуска не указана'; // Поле для даты выпуска
    final developer = product['developer'] ?? 'Разработчик не указан'; // Поле для разработчика

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Если URL изображения указан, отображаем изображение
              if (imageUrl.isNotEmpty)
                Center(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 300,
                  ),
                ),
              const SizedBox(height: 16),

              // Отображение названия продукта
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),

              // Отображение описания продукта
              Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Отображение цены продукта
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),

              // Отображение жанра продукта
              Text(
                'Жанр: $genre',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),

              // Отображение даты выпуска
              Text(
                'Дата выпуска: $releaseDate',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),

              // Отображение разработчика продукта
              Text(
                'Разработчик: $developer',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
