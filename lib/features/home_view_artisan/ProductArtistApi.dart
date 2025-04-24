import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProductArtistModel.dart';

class ProductArtistApi {
  static const String baseUrl = 'http://abdoemam.runasp.net';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<bool> _isTokenExpired(String token) async {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }

  static Future<void> _refreshToken() async {
    print("Token expired. Please refresh or re-login.");
  }

  static Future<Dio> _getDioClient() async {
    Dio dio = Dio();
    final token = await _getToken();

    if (token != null) {
      bool isExpired = await _isTokenExpired(token);
      if (isExpired) {
        await _refreshToken();
        throw Exception("Token expired. Please re-login.");
      }

      dio.options.headers = {
        'Authorization': 'Bearer $token',
      };
    }

    dio.options.headers['Content-Type'] = 'application/json';
    return dio;
  }

  static Future<String> uploadImage(
      String filePath, List<String> craftCategories) async {
    try {
      Dio dio = await _getDioClient();
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        'craftCategory': craftCategories,
      });

      final url = '$baseUrl/api/Products/upload-image';
      final response = await dio.post(url, data: formData);

      if (response.statusCode == 200) {
        return response.data['imageUrl'];
      } else {
        throw Exception('فشل في تحميل الصورة');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء تحميل الصورة: $e');
    }
  }

  static Future<void> addProduct(ProductArtistModel product) async {
    try {
      Dio dio = await _getDioClient();
      final response =
      await dio.post('$baseUrl/api/Products', data: product.toJson());
      if (response.statusCode != 201) {
        throw Exception('فشل في إضافة المنتج');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء إضافة المنتج: $e');
    }
  }


  // ✅ تعديل دالة تحديث المنتج بناءً على الـ API و الـ Token
  static Future<void> updateProduct(int id, ProductArtistModel product) async {
    try {
      Dio dio = await _getDioClient();

      // التأكد من أن الـ category موجودة
      if (product.category == null || product.category!.isEmpty) {
        throw Exception("Category is required");
      }

      final response = await dio.put(
        '$baseUrl/api/Products/$id',
        data: product.toJson(), // البيانات المرسلة لتحديث المنتج
      );

      if (response.statusCode == 200) {
        print("تم تحديث المنتج بنجاح");
      } else {
        print("خطأ: ${response.statusCode} - ${response.data}");
        throw Exception('فشل في تحديث المنتج');
      }
    } catch (e) {
      print("حدث خطأ أثناء تحديث المنتج: $e");
      throw Exception('حدث خطأ أثناء تحديث المنتج: $e');
    }
  }



  static Future<void> deleteProduct(int id) async {
    try {
      Dio dio = await _getDioClient();
      final response = await dio.delete('$baseUrl/api/Products/$id');
      if (response.statusCode != 200) {
        throw Exception('فشل في حذف المنتج');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء حذف المنتج: $e');
    }
  }

  static Future<List<ProductArtistModel>> getAllProducts() async {
    try {
      Dio dio = await _getDioClient();
      final url = '$baseUrl/api/Products';
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => ProductArtistModel.fromJson(json)).toList();
      } else {
        throw Exception('فشل في جلب المنتجات');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء جلب المنتجات: $e');
    }
  }

  static Future<ProductArtistModel> getProductById(int id) async {
    try {
      Dio dio = await _getDioClient();
      final url = '$baseUrl/Products/$id';
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        return ProductArtistModel.fromJson(response.data);
      } else {
        throw Exception('فشل في جلب المنتج');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء جلب المنتج: $e');
    }

  }

  // ✅ دالة جديدة لعرض منتجات التاجر فقط
  static Future<List<ProductArtistModel>> getMerchantProducts() async {
    try {
      Dio dio = await _getDioClient();
      final url =
          '$baseUrl/api/Products/mine'; // endpoint حسب الباك اند عندك
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => ProductArtistModel.fromJson(json)).toList();
      } else {
        throw Exception('فشل في جلب منتجات التاجر');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء جلب منتجات التاجر: $e');
    }
  }
}
