import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_local_artisans/features/AccountScreen/UpdateUserProfile.dart';

class ProfileApi {
  static Future<bool> updateProfile({
    required String displayName,
    required String phoneNumber,
  }) async {
    try {
      final dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Content-Type'] = 'application/json';

      final data = {
        'displayName': displayName,
        'phoneNumber': phoneNumber,
      };

      final response = await dio.put(
        'http://abdoemam.runasp.net/api/Account/UpdateBasicProfile',
        data: data,
      );

      if (response.statusCode == 200) {
        return true; // Successfully updated profile
      } else {
        return false; // Failed to update profile
      }
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }


  static Future<UpdateUserProfile?> getCurrentUser() async {
    try {
      // إعداد Dio
      final dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Content-Type'] = 'application/json';

      // إرسال الطلب للحصول على بيانات المستخدم الحالي
      final response = await dio.get(
        'http://abdoemam.runasp.net/api/Account/GetCurentUser',
      );

      // إذا كانت الاستجابة 200، قم بتحويلها إلى UpdateUserProfile
      if (response.statusCode == 200) {
        return UpdateUserProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to get current user');
      }
    } catch (e) {
      print('Error fetching current user: $e');
      return null;
    }
  }
}
