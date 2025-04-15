import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // استيراد الباكيدج
import '../../../CartScreen/CartApi.dart';
import '../../../CartScreen/CartScreen.dart';
import 'ProductModel.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsScreen({super.key, required this.product});

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Retrieved Token: $token');
    return token;
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

  Future<bool> _addToCartAndNavigate(
      BuildContext context, ProductModel product) async {
    final dio = Dio();
    final token = await getToken();
    final userId = await getUserIdFromToken(); // استخراج userId من التوكن

    if (token == null) {
      print('No token found, cannot add to cart.');
      Get.snackbar('Error', 'Not authenticated',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Content-Type'] = 'application/json';

    String basketId;
    if (userId != null) {
      basketId = "Basket_$userId"; // استخدام userId الديناميكي
    } else {
      basketId = "Basket_Guest"; // الرجوع للـ Guest ID في حالة عدم وجود userId
      print('User ID not found in token, using Guest Basket ID.');
    }

    final body = {
      "id": basketId,
      "items": [
        {
          "Id": product.id,
          "Name": product.title,
          "PictureUrl": product.imageUrl,
          "price": product.price,
          "Brand": product.brand,
          "Type": product.type,
          "Quantity": 1
        }
      ]
    };

    print('Adding to cart with body: $body');
    print('Headers being sent: ${dio.options.headers}');

    try {
      final response = await dio.post(
        'http://abdoemam.runasp.net/api/Basket/',
        data: body,
      );
      print('Add to cart response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        Get.find<CartController>().fetchCartItems();
        Get.to(() => CartScreen(initialProduct: product));
        return true;
      } else {
        Get.snackbar('Error', 'Failed to add to cart',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      print('Error adding to cart: $e');
      Get.snackbar('Error', 'Error adding to cart',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl, height: 200),
            const SizedBox(height: 16),
            Text(product.title, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 8),
            Text("Price: \$${product.price}"),
            const SizedBox(height: 8),
            Text("Brand: ${product.brand}"),
            const SizedBox(height: 8),
            Text("Type: ${product.type}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _addToCartAndNavigate(context, product),
              child: const Text("Add to Cart"),
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

// ... (باقي دوال الكنترولر)
}
