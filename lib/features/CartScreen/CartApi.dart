// cart_api.dart
import 'package:dio/dio.dart';
import 'package:support_local_artisans/features/CartScreen/CartItemModel.dart';

class CartApi {
  static Future<List<CartItemModel>> getCartItems() async {
    final response = await Dio().get("https://api.example.com/cart");
    return (response.data as List)
        .map((item) => CartItemModel.fromJson(item))
        .toList();
  }
}
