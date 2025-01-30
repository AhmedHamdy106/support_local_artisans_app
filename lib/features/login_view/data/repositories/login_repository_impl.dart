import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:support_local_artisans/core/error/failures.dart';
import 'package:support_local_artisans/features/login_view/data/data_sources/remote_data_source/login_remote_data_source.dart';
import 'package:support_local_artisans/features/login_view/domain/entities/LoginResponseEntity.dart';
import '../../domain/repositories/login_repository.dart';

@Injectable(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  LoginRemoteDataSource loginRemoteDataSource;
  LoginRepositoryImpl({required this.loginRemoteDataSource});
  @override
  Future<Either<LoginResponseEntity, Failures>> login(
    String email,
    String password,
  ) async {
    var either = await loginRemoteDataSource.login(
      email,
      password,
    );
    return either.fold(
      (response) => Left(response),
      (error) => Right(error),
    );
  }
}
