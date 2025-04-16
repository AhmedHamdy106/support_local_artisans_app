import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../home_view/presentation/tabs/cart_screen.dart';
import '../home_view_user/presentation/pages/ProductDetailsScreen.dart';
import '../home_view_user/presentation/pages/ProductModel.dart';
import 'CartItemModel.dart';

class CartApi extends GetxService {
  final Dio _dio = Dio();

  Future<void> _setAuthHeader() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && !JwtDecoder.isExpired(token)) {
      _dio.options.headers["Authorization"] = "Bearer $token";
    } else {
      _dio.options.headers.remove("Authorization");
    }
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && !JwtDecoder.isExpired(token)) {
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['nameid'];
    }
    return null;
  }

  Future<List<CartItemModel>> getCartItems() async {
    await _setAuthHeader();
    final userId = await _getUserId();
    if (userId == null) {
      print("User not authenticated, cannot fetch cart items.");
      return [];
    }
    try {
      final response = await _dio.get(
        "http://abdoemam.runasp.net/api/Basket/$userId", // Use user ID as basket identifier
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return [CartItemModel.fromJson(data)];
      } else if (data is List) {
        return data.map((item) => CartItemModel.fromJson(item)).toList();
      } else {
        print("Unexpected response format for getCartItems: $data");
        return [];
      }
    } on DioException catch (e) {
      print(
          "Error fetching cart items: ${e.response?.statusCode} - ${e.message}");
      if (e.response?.statusCode == 401) {
        // Handle unauthorized error
      }
      return [];
    } catch (e) {
      print("Error fetching cart items: $e");
      return [];
    }
  }

  Future<void> updateCart(CartItemModel cart) async {
    await _setAuthHeader();
    final userId = await _getUserId();
    if (userId == null) {
      print("User not authenticated, cannot update cart.");
      return;
    }
    try {
      await _dio.put(
        "http://abdoemam.runasp.net/api/Basket/$userId",
        data: cart.toJson(),
      );
    } on DioException catch (e) {
      print("Error updating cart: ${e.response?.statusCode} - ${e.message}");
      if (e.response?.statusCode == 401) {
        // Handle unauthorized error
      }
    } catch (e) {
      print("Error updating cart: $e");
    }
  }

  Future<void> removeItem(int itemId) async {
    await _setAuthHeader();
    final userId = await _getUserId();
    if (userId == null) {
      print("User not authenticated, cannot remove item.");
      return;
    }
    try {
      await _dio.delete(
        "http://abdoemam.runasp.net/api/Basket/$userId/items/$itemId", // Specific endpoint for removing item
      );
    } on DioException catch (e) {
      print("Error removing item: ${e.response?.statusCode} - ${e.message}");
      if (e.response?.statusCode == 401) {
        // Handle unauthorized error
      }
    } catch (e) {
      print("Error removing item: $e");
    }
  }

  Future<bool> clearCart() async {
    await _setAuthHeader();
    final userId = await _getUserId();
    if (userId == null) {
      print("User not authenticated, cannot clear cart.");
      return false;
    }
    try {
      final response = await _dio.delete(
        "http://abdoemam.runasp.net/api/Basket/$userId", // DELETE request to clear the entire basket
      );
      return response.statusCode == 204;
    } on DioException catch (e) {
      print("Error clearing cart: ${e.response?.statusCode} - ${e.message}");
      if (e.response?.statusCode == 401) {
        // Handle unauthorized error
      }
      return false;
    } catch (e) {
      print("Error clearing cart: $e");
      return false;
    }
  }

  Future<bool> addProductToCart(
      BuildContext context, ProductModel product) async {
    final dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      Get.snackbar('Error', 'Not authenticated',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Content-Type'] = 'application/json';

    String? userId;
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      userId = decodedToken[
          "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];
    } catch (e) {
      print('Error decoding token: $e');
    }

    final String basketId = userId != null ? "Basket_$userId" : "Basket_Guest";

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
        print(response.statusCode);
        print(response.data);
        Get.find<CartController>().fetchCartItems();
        Get.to(() => CartScreen(initialProduct: product));
        return true;
      } else {
        Get.snackbar('Error', 'Failed to add to cart: ${response.statusCode}',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      print('Error adding to cart: $e');
      String errorMessage = 'Error adding to cart';
      if (e is DioException && e.response?.data != null) {
        errorMessage = 'Error adding to cart: ${e.response?.data}';
        print('Error response data: ${e.response?.data}');
      }
      Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  Future<void> updateItemQuantity(
    int itemId, // Use itemId to identify the specific item
    int newQuantity,
  ) async {
    await _setAuthHeader();
    final userId = await _getUserId();
    if (userId == null) {
      print("User not authenticated, cannot update item quantity.");
      return;
    }
    try {
      await _dio.put(
        "http://abdoemam.runasp.net/api/Basket/$userId/items/$itemId", // Specific endpoint for updating item
        data: {"quantity": newQuantity},
      );
    } on DioException catch (e) {
      print(
          "Error updating item quantity: ${e.response?.statusCode} - ${e.message}");
      if (e.response?.statusCode == 401) {
        // Handle unauthorized error
      }
    } catch (e) {
      print("Error updating item quantity: $e");
    }
  }
}
