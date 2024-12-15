import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(product);

    final name = product['Name'] ?? 'Без названия';
    final imageUrl = product['ImageURL'] ?? '';
    final description = product['Description'] ?? 'Нет описания';
    final price = product['Price'] != null ? '\Р${product['Price']}' : 'Цена не указана';

    final genre = product['genre'] ?? 'Жанр не указан'; 
    final releaseDate = product['releaseDate'] ?? 'Дата выпуска не указана'; 
    final developer = product['developer'] ?? 'Разработчик не указан'; 

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

              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Жанр: $genre',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),

              Text(
                'Дата выпуска: $releaseDate',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),

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
