import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pcs_11/components/product_card.dart';
import 'package:pcs_11/widgets/add_product_dialog.dart';
import 'package:pcs_11/pages/main_home/shopping_page.dart';
import 'package:pcs_11/pages/main_home/product_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _notesStream = Supabase.instance.client.from('notes').stream(primaryKey: ['id']);
  final List<Map<String, dynamic>> _cartItems = [];
  String _searchQuery = ''; // Переменная для хранения запроса поиска
  bool _isSearching = false; // Флаг для показа строки поиска

  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => const AddProductDialog(),
    );
  }

  void addToCart(Map<String, dynamic> product) {
    setState(() {
      _cartItems.add(product);
    });
  }

  // Функция для фильтрации товаров по запросу поиска
  List<Map<String, dynamic>> _filterNotes(List<Map<String, dynamic>> notes) {
    if (_searchQuery.isEmpty) {
      return notes;
    }
    return notes.where((note) {
      final name = note['Name']?.toLowerCase() ?? '';
      return name.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: addNewNote,
        ),
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Поиск товаров...',
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              )
            : const Text('Видеоигры'),
        centerTitle: true,
        actions: [
          // Иконка поиска с отступом слева
          Padding(
            padding: const EdgeInsets.only(right: 8.0), // Отступ справа для корзины
            child: IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching; // Переключение режима поиска
                  _searchQuery = ''; // Очистка строки поиска
                });
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems: _cartItems),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF67BEEA),
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

          final filteredNotes = _filterNotes(notes); // Применение фильтрации

          if (filteredNotes.isEmpty) {
            return const Center(child: Text('Товары не найдены'));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.5,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            padding: const EdgeInsets.all(10.0),
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              final note = filteredNotes[index];
              final name = note['Name'] ?? 'Без названия';
              final imageUrl = note['ImageURL'] ?? '';
              final description = note['Description'] ?? 'Нет описания';
              final price = note['Price'] != null ? '\Р${note['Price']}' : 'Цена не указана';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: note),
                    ),
                  );
                },
                child: ProductCard(
                  name: name,
                  imageUrl: imageUrl,
                  description: description,
                  price: price,
                ),
              );
            },
          );
        },
      ),
    );
  }
}