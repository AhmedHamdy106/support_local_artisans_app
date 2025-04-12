import 'package:dio/dio.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/CategoryModel.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/ProductModel.dart';

class HomeApi {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://abdoemam.runasp.net/api/',
    connectTimeout: Duration(milliseconds: 5000),
    receiveTimeout: Duration(milliseconds: 3000),
  ));

  // ✅ Get all categories (with fallback if response is a List)
  static Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get("Category");
      final responseData = response.data;
      print("📦 Category Response: $responseData");

      if (responseData != null && responseData is Map && responseData['data'] != null) {
        return (responseData['data'] as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      } else if (responseData is List) {
        return responseData
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("❌ Error fetching categories: $e");
      return [];
    }
  }

  // ✅ Get products by category
  static Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await _dio.get("Category?category=$category");
      print("📦 Products by category response: ${response.data}");

      if (response.data != null && response.data is List) {
        return (response.data as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("❌ Error fetching products by category: $e");
      return [];
    }
  }

  // ✅ Get all products
  static Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _dio.get("Products");
      print("📦 Products response: ${response.data}");

      if (response.data != null && response.data is List) {
        return (response.data as List)
            .map((e) => ProductModel.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("❌ Error fetching products: $e");
      return [];
    }
  }

  // ✅ Search products by name
  static Future<List<ProductModel>> searchProducts(String productName) async {
    try {
      final response = await _dio.get(
        'Products/Search',
        queryParameters: {'name': productName},
      );
      if (response.statusCode == 200 && response.data != null) {
        return (response.data as List)
            .map((product) => ProductModel.fromJson(product))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print("❌ Error searching products: $e");
      return [];
    }
  }
}
