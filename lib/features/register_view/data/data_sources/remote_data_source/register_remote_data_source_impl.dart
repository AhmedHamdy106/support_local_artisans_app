import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:support_local_artisans/core/api/api_manager.dart';
import 'package:support_local_artisans/core/api/end_points.dart';
import 'package:support_local_artisans/core/error/failures.dart';
import 'package:support_local_artisans/features/register_view/data/data_sources/remote_data_source/register_remote_data_source.dart';
import 'package:support_local_artisans/features/register_view/data/models/RegisterResponseDM.dart';

@Injectable(as: RegisterRemoteDataSource)
class RegisterRemoteDataSourceImpl implements RegisterRemoteDataSource {
  @override
  Future<Either<RegisterResponseDM, Failures>> register(String name,
      String email, String password, String rePassword, String phone) async {
    var response = await ApiManager.postData(
      EndPoints.registerEndPoint,
      body: {
        "name": name,
        "email": email,
        "password": password,
        "rePassword": rePassword,
        "phone": phone,
      },
    );
    var registerResponse = RegisterResponseDM.fromJson(response.data);
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return Left(registerResponse);
    } else {
      return Right(ServerError(errorMessage: registerResponse.message!));
    }
  }
}
