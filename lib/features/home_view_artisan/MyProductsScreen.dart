import 'package:flutter/material.dart';

import 'EditProductScreen.dart';
import 'ProductArtistApi.dart';
import 'ProductArtistModel.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  List<ProductArtistModel> products = [];
  List<String> _categories = [];
  String? _selectedCategory;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMyProducts();
  }

  Future<void> fetchMyProducts() async {
    try {
      final result = await ProductArtistApi.getMerchantProducts();
      setState(() {
        products = result;
        _categories = result
            .map((e) => e.category)
            .whereType<String>()
            .toSet()
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error loading merchant products: $e");
      setState(() => isLoading = false);
    }
  }


  Future<void> _deleteProduct(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Product"),
        content: Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text("Delete")),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ProductArtistApi.deleteProduct(id);
        await fetchMyProducts();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product deleted")));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to delete")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedProducts = _selectedCategory == null
        ? products
        : products.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("My Products"),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? Center(child: Text("You haven't added any products yet."))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text("Filter by Category"),
              value: _selectedCategory,
              isExpanded: true,
              items: [
                DropdownMenuItem(value: null, child: Text("All")),
                ..._categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: displayedProducts.length,
                itemBuilder: (context, index) {
                  final product = displayedProducts[index];
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      leading: Image.network(
                        product.pictureUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(Icons.image),
                      ),
                      title: Text(product.name!),
                      subtitle: Text("${product.price} JD"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProductScreen(product: product),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteProduct(product.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}