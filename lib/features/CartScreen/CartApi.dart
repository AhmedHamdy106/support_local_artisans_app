import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_local_artisans/features/CartScreen/BasketItem.dart';

import '../home_view_user/presentation/pages/ProductModel.dart';

class CartApi {
  // حذف منتج من السلة بناءً على الـ id
  static Future<bool> removeProductFromCart(
      BuildContext context, int productId) async {
    final dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Not authenticated')),
      );
      return false;
    }

    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Content-Type'] = 'application/json';

    try {
      final response = await dio.delete(
        'http://abdoemam.runasp.net/api/Basket/remove-item/$productId', // استخدام الـ productId هنا
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Product removed from cart successfully')),
        );
        return true; // تم حذف المنتج بنجاح
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to remove product. Status: ${response.statusCode}'),
          ),
        );
        return false;
      }
    } catch (e) {
      print("Error removing product: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error removing product: $e')),
      );
      return false;
    }
  }

  static Future<bool> addProductToCart(
      BuildContext context, ProductModel widgetProduct) async {
    final dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Not authenticated')),
      );
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
      return false;
    }

    final String basketId = userId != null ? "Basket_$userId" : "Basket_Guest";

    try {
      final existingResponse = await dio.get(
        'http://abdoemam.runasp.net/api/Basket/',
      );

      List<dynamic> existingItems = [];
      if (existingResponse.statusCode == 200 &&
          existingResponse.data != null &&
          existingResponse.data['items'] != null) {
        existingItems = existingResponse.data['items'];
      }

      bool productExists = false;
      for (var item in existingItems) {
        if (item['id'] == widgetProduct.id) {
          // تعديل هنا ليكون id من النوع int
          item['quantity'] += 1;
          productExists = true;
          break;
        }
      }

      if (!productExists) {
        existingItems.add({
          "id": widgetProduct.id, // تعديل هنا ليكون id من النوع int
          "name": widgetProduct.name,
          "pictureUrl": widgetProduct.pictureUrl,
          "brand": widgetProduct.brand,
          "type": widgetProduct.type,
          "price": widgetProduct.price,
          "quantity": 1
        });
      }

      final updatedBasket = {
        "id": basketId,
        "items": existingItems,
      };

      final response = await dio.post(
        'http://abdoemam.runasp.net/api/Basket/',
        data: updatedBasket,
      );

      if (response.statusCode == 200) {
        return true; // تم تحديث السلة بنجاح على الـ Backend
      } else {
        print("Failed to update basket: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error updating basket: $e");
      return false;
    }
  }

  static Future<List<BasketItem>> getBasketItems() async {
    final dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) throw Exception('Token not found');

    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Content-Type'] = 'application/json';

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final String? userId = decodedToken[
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];
    final String basketId = userId != null ? "Basket_$userId" : "Basket_Guest";

    final response = await dio.get('http://abdoemam.runasp.net/api/Basket/');

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      if (data['items'] != null) {
        return (data['items'] as List)
            .map((item) => BasketItem.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load cart');
    }
  }

  // دالة حذف السلة
  static Future<bool> deleteBasket(BuildContext context) async {
    final dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Not authenticated')),
      );
      return false;
    }

    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Content-Type'] = 'application/json';

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    final String? userId = decodedToken[
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];
    final String basketId = userId != null ? "Basket_$userId" : "Basket_Guest";

    try {
      final response = await dio.delete(
        'http://abdoemam.runasp.net/api/Basket/',
        queryParameters: {'BasketId': basketId},
      );

      if (response.statusCode == 200) {
        return true; // تم حذف السلة بنجاح
      } else {
        print('Failed to delete basket: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print("Error deleting basket: $e");
      return false;
    }
  }

  // دالة تحديث كمية المنتج في السلة
  static Future<bool> updateProductQuantity(
      BuildContext context, int productId, int newQuantity) async {
    final dio = Dio();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Not authenticated')),
      );
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
      return false;
    }

    final String basketId = userId != null ? "Basket_$userId" : "Basket_Guest";

    try {
      final response = await dio.get('http://abdoemam.runasp.net/api/Basket/');

      if (response.statusCode == 200) {
        List<dynamic> items = response.data['items'] ?? [];

        // إيجاد المنتج وتحديث الكمية
        for (var item in items) {
          if (item['id'] == productId) {
            item['quantity'] = newQuantity; // تحديث الكمية
            break;
          }
        }

        final updatedBasket = {
          "id": basketId,
          "items": items,
        };

        final updateResponse = await dio.post(
          'http://abdoemam.runasp.net/api/Basket/',
          data: updatedBasket,
        );

        return updateResponse.statusCode == 200;
      }
      return false;
    } catch (e) {
      print("Error updating quantity: $e");
      return false;
    }
  }
}
