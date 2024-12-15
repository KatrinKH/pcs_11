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
  String _searchQuery = ''; 
  bool _isSearching = false; 

  String _sortCriteria = 'Сбросить'; 
  List<Map<String, dynamic>>? _originalNotes; 

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

  List<Map<String, dynamic>> _sortNotes(List<Map<String, dynamic>> notes) {
    switch (_sortCriteria) {
      case 'Дешевле':
        notes.sort((a, b) => (a['Price'] ?? 0).compareTo(b['Price'] ?? 0));
        break;
      case 'Дороже':
        notes.sort((a, b) => (b['Price'] ?? 0).compareTo(a['Price'] ?? 0));
        break;
      case 'По алфавиту':
        notes.sort((a, b) => (a['Name'] ?? '').compareTo(b['Name'] ?? ''));
        break;
      case 'Сбросить':
      default:
        return _originalNotes ?? notes;
    }
    return notes;
  }

  List<Map<String, dynamic>> _filterNotes(List<Map<String, dynamic>> notes) {
    if (_searchQuery.isEmpty) {
      return notes;
    }
    return notes.where((note) => note['Name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Выберите критерий сортировки'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Дешевле'),
                        onTap: () {
                          setState(() {
                            _sortCriteria = 'Дешевле';
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Дороже'),
                        onTap: () {
                          setState(() {
                            _sortCriteria = 'Дороже';
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('По алфавиту'),
                        onTap: () {
                          setState(() {
                            _sortCriteria = 'По алфавиту';
                          });
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Сбросить'),
                        onTap: () {
                          setState(() {
                            _sortCriteria = 'Сбросить';
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
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
            : const Text('Видеоигры'), // Corrected this line
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: addNewNote,
          ),
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                _searchQuery = '';
              });
            },
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

          _originalNotes ??= List.from(notes);

          final sortedNotes = _sortNotes(List.from(notes));
          final filteredNotes = _filterNotes(sortedNotes);

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