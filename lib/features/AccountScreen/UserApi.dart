// user_api.dart
import 'package:dio/dio.dart';
import 'package:support_local_artisans/features/AccountScreen/UserModel.dart';

class UserApi {
  static Future<UserModel> getUserProfile() async {
    final response = await Dio().get("https://api.example.com/user");
    return UserModel.fromJson(response.data);
  }
}
