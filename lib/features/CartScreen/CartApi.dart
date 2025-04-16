import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_local_artisans/features/CartScreen/BasketItem.dart';
import '../home_view_user/presentation/pages/ProductModel.dart';

class CartApi {
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

    // ✅ 1. Get existing basket from backend
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

      // ✅ 2. Check if product already exists in basket
      bool productExists = false;
      for (var item in existingItems) {
        if (item['id'] == widgetProduct.id) {
          item['quantity'] += 1; // ✅ زيادة الكمية
          productExists = true;
          break;
        }
      }

      // ✅ 3. If not exist, add it to the list
      if (!productExists) {
        existingItems.add({
          "Id": widgetProduct.id,
          "Name": widgetProduct.title,
          "PictureUrl": widgetProduct.imageUrl,
          "price": widgetProduct.price,
          "Brand": widgetProduct.brand,
          "Type": widgetProduct.type,
          "Quantity": 1
        });
      }

      // ✅ 4. Send updated basket
      final updatedBasket = {
        "id": basketId,
        "items": existingItems,
      };

      final response = await dio.post(
        'http://abdoemam.runasp.net/api/Basket/',
        data: updatedBasket,
      );

      if (response.statusCode == 200) {
        return true;
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
    final String? userId = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];
    final String basketId = userId != null ? "Basket_$userId" : "Basket_Guest";

    final response = await dio.get('http://abdoemam.runasp.net/api/Basket/');

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      if (data['items'] != null) {
        return (data['items'] as List).map((item) => BasketItem.fromJson(item)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load cart');
    }
  }

}
