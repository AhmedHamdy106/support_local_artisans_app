import 'package:flutter/material.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/features/CartScreen/CartApi.dart';
import 'package:support_local_artisans/features/home_view_artisan/EditProductScreen.dart';
import '../../config/routes_manager/routes.dart';
import '../../core/shared/shared_preference.dart';
import '../home_view_user/presentation/pages/MainScreen.dart';
import 'ProductArtistApi.dart'; // تأكد من أنك قد أضفت الـ API هنا
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

  // Fetch products from API
  Future<void> fetchMyProducts() async {
    try {
      final result = await ProductArtistApi
          .getMerchantProducts(); // الحصول على المنتجات الخاصة بالتاجر
      setState(() {
        products = result;
        _categories = result
            .map((e) =>
        e.category) // التأكد من أن لديك خاصية category في الـ Model
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

  // Delete product
  Future<void> _deleteProduct(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Product"),
        content: Text("Are you sure you want to delete this product?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true), child: Text("Delete")),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ProductArtistApi.deleteProduct(id); // حذف المنتج
        await fetchMyProducts(); // إعادة تحميل المنتجات بعد الحذف
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Product deleted")));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to delete")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access current theme

    final displayedProducts = _selectedCategory == null
        ? products
        : products.where((p) => p.category == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Use theme background color
      appBar: AppBar(
        title: Text(
          "My Products",
          style: TextStyle(color: theme.textTheme.bodyLarge?.color), // Use text color from theme
        ),
        centerTitle: true,
        backgroundColor: theme.primaryColor, // Use primary color from theme
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? Center(child: Text("You haven't added any products yet.", style: TextStyle(color: theme.textTheme.bodyLarge?.color)))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text("Filter by Category", style: TextStyle(color: theme.textTheme.bodyLarge?.color)), // Use text color from theme
              value: _selectedCategory,
              isExpanded: true,
              items: [
                DropdownMenuItem(value: null, child: Text("All", style: TextStyle(color: theme.textTheme.bodyLarge?.color))), // Use text color from theme
                ..._categories.map((cat) =>
                    DropdownMenuItem(value: cat, child: Text(cat, style: TextStyle(color: theme.textTheme.bodyLarge?.color)))) // Use text color from theme
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
                    elevation: 5,
                    color: theme.cardColor, // Use card color from theme
                    child: ListTile(
                      leading: Image.network(
                        product.pictureUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.image, color: theme.iconTheme.color), // Use icon color from theme
                      ),
                      title: Text(product.name!, style: TextStyle(color: theme.textTheme.bodyLarge?.color)), // Use text color from theme
                      subtitle: Text("${product.price} EGP", style: TextStyle(color: theme.textTheme.bodyLarge?.color)), // Use text color from theme
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: theme.iconTheme.color), // Use icon color from theme
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProductScreen(
                                      product: product),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _deleteProduct(product.id!),
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
