import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../CartScreen/CartApi.dart';
import '../../../CartScreen/CartScreen.dart';
import 'ProductModel.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getUserIdFromToken() async {
    final token = await getToken();
    if (token != null) {
      try {
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        return decodedToken[
            "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];
      } catch (e) {
        print('Error decoding token: $e');
      }
    }
    return null;
  }

  Future<bool> _addToCartAndNavigate() async {
    final dio = Dio();
    final token = await getToken();
    final userId = await getUserIdFromToken();

    if (token == null) {
      Get.snackbar('Error', 'Not authenticated',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Content-Type'] = 'application/json';

    final basketId = userId != null ? "Basket_\$userId" : "Basket_Guest";

    final body = {
      "id": basketId,
      "items": [
        {
          "Id": widget.product.id,
          "Name": widget.product.title,
          "PictureUrl": widget.product.imageUrl,
          "price": widget.product.price,
          "Brand": widget.product.brand,
          "Type": widget.product.type,
          "Quantity": _quantity
        }
      ]
    };

    try {
      final response = await dio.post(
        'http://abdoemam.runasp.net/api/Basket/',
        data: body,
      );
      if (response.statusCode == 200) {
        Get.find<CartController>().fetchCartItems();
        Get.to(() => CartScreen(initialProduct: widget.product));
        return true;
      } else {
        Get.snackbar('Error', 'Failed to add to cart',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Error adding to cart',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Product Details'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.shopping_cart_outlined), onPressed: () {}),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.3), width: 2.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.network(
                        widget.product.imageUrl,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Text(
                          '3,230 Sold',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      const Text('4.8 (7,500)',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Description',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade200))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Total price', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text(
                  'EGP ${widget.product.price * _quantity}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _addToCartAndNavigate,
                  icon:
                      const Icon(Icons.add_shopping_cart, color: Colors.white),
                  label: const Text('Add to cart'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8C4931),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CartController extends GetxController {
  RxList<dynamic> cartItems = <dynamic>[].obs;

  Future<void> fetchCartItems() async {
    final List<dynamic> fetchedItems = await CartApi().getCartItems();
    if (fetchedItems != null) {
      cartItems.value = fetchedItems;
    } else {
      cartItems.value = [];
      Get.snackbar('Error', 'Failed to fetch cart items',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
