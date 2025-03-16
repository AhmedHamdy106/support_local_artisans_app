import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:support_local_artisans/core/utils/app_strings.dart';

@singleton
class ApiManager {
  static late Dio dio;
  ApiManager() {
    dio = Dio();
  }
  static Future<Response> getData(String endPoint,
      {Map<String, dynamic>? queryParameters}) {
    return dio.get(
      AppStrings.baseUrl + endPoint,
      queryParameters: queryParameters,
      options: Options(
        validateStatus: (status) => true,
      ),
    );
  }

  static Future<Response> postData(String endPoint,
      {Map<String, dynamic>? body, Map<String, dynamic>? headers}) {
    return dio.post(
      AppStrings.baseUrl + endPoint,
      data: body,
      options: Options(
        headers: headers,
        contentType: 'application/json',
        validateStatus: (status) => true,
      ),
    );
  }
}
