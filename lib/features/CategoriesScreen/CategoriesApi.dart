import 'package:dio/dio.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/CategoryModel.dart';

class CategoriesApi {
  static final Dio _dio = Dio();

  // إضافة الفئة كـ parameter
  static Future<List<CategoryModel>> getCategories(String category) async {
    try {
      final response = await _dio.get(
          "http://abdoemam.runasp.net/api/Category?category=$category"
      );
      final responseData = response.data;

      // تأكد أن البيانات هي قائمة من الفئات
      if (responseData != null && responseData is List) {
        return responseData.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      // التعامل مع الأخطاء
      print("Error fetching categories: $e");
      return [];
    }
  }
}
