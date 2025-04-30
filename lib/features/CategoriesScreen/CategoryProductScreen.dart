import 'package:flutter/material.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/HomeApi.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/ProductModel.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/ProductCard.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/ProductDetailsScreen.dart';
import '../../config/routes_manager/routes.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<ProductModel> categoryProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  Future<void> fetchCategoryProducts() async {
    try {
      final products = await HomeApi.getProductsByCategory(widget.categoryName);
      setState(() {
        categoryProducts = products;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching products: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access current theme

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Use theme background color
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.iconTheme.color), // Use icon color from theme
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: theme.appBarTheme.backgroundColor, // Use theme app bar color
        elevation: 0,
        title: Text(
          widget.categoryName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color, // Use theme text color
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
          : categoryProducts.isEmpty
          ? Center(
        child: Text(
          "No products found.",
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: categoryProducts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            return ProductCard(
              product: categoryProducts[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(
                        product: categoryProducts[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
