import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
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
}
