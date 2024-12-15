import 'package:flutter/material.dart';
import 'package:pcs_11/components/product_card.dart';

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;

  const CartPage({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text('Корзина пуста'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                final name = item['Name'] ?? 'Без названия';
                final imageUrl = item['ImageURL'] ?? '';
                final description = item['Description'] ?? 'Нет описания';
                final price = item['Price'] != null ? '\Р${item['Price']}' : 'Цена не указана';

                return ProductCard(
                  name: name,
                  imageUrl: imageUrl,
                  description: description,
                  price: price,
                );
              },
            ),
    );
  }
}
