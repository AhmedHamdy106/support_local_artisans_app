import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_local_artisans/core/api/api_manager.dart';
import 'package:support_local_artisans/core/api/end_points.dart';
import 'package:support_local_artisans/core/error/failures.dart';
import 'package:support_local_artisans/features/login_view/data/models/LoginResponseDM.dart';
import 'login_remote_data_source.dart';

@Injectable(as: LoginRemoteDataSource)
class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  @override
  Future<Either<LoginResponseDM, Failures>> login(
    String email,
    String password,
    bool RememberMe,
  ) async {
    var response = await ApiManager.postData(
      EndPoints.loginEndPoint,
      body: {
        "email": email,
        "password": password,
        "RememberMe": RememberMe,
      },
    );
    var loginResponse = LoginResponseDM.fromJson(response.data);
    if (response.statusCode! >= 200 && response.statusCode! < 300) {

      return Left(loginResponse);
    } else {
      return Right(ServerError(errorMessage: loginResponse.message ?? ''));
    }
  }
  Future<void> saveLoginData(String token, String email, String password, bool rememberMe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setBool("remember_me", rememberMe);

    if (rememberMe) {
      await prefs.setString("auth_token", token);
      await prefs.setString("email", email);
      await prefs.setString("password", password);
    } else {
      await prefs.remove("auth_token");
      await prefs.remove("email");
      await prefs.remove("password");
    }

    print("Login Data Saved: Remember Me = $rememberMe");
  }
}
