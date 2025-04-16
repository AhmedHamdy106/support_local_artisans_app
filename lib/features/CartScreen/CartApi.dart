import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error decoding token: $e')),
      );
      return false;
    }

    final String basketId = userId != null ? "Basket_$userId" : "Basket_Guest";

    final body = {
      "id": basketId,
      "items": [
        {
          "Id": widgetProduct.id,
          "Name": widgetProduct.title,
          "PictureUrl": widgetProduct.imageUrl,
          "price": widgetProduct.price,
          "Brand": widgetProduct.brand,
          "Type": widgetProduct.type,
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
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error: Failed to add to cart: ${response.statusCode}')),
        );
        return false;
      }
    } catch (e) {
      print('Error adding to cart: $e');
      String errorMessage = 'Error adding to cart';
      if (e is DioException && e.response?.data != null) {
        errorMessage = 'Error adding to cart: ${e.response?.data}';
        print('Error response data: ${e.response?.data}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      return false;
    }
  }
}
