import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:support_local_artisans/core/error/failures.dart';
import 'package:support_local_artisans/features/register_view/domain/entities/RegisterResponseEntity.dart';
import 'package:support_local_artisans/features/register_view/domain/repositories/register_repository.dart';
import '../data_sources/remote_data_source/register_remote_data_source.dart';

@Injectable(as: RegisterRepository)
class RegisterRepositoryImpl implements RegisterRepository {
  RegisterRemoteDataSource registerRemoteDataSource;
  RegisterRepositoryImpl({required this.registerRemoteDataSource});
  @override
  Future<Either<RegisterResponseEntity, Failures>> register(String name,
      String email, String password, String rePassword, String phone) async {
    var either = await registerRemoteDataSource.register(
      name,
      email,
      password,
      rePassword,
      phone,
    );
    return either.fold(
      (response) => Left(response),
      (error) => Right(error),
    );
  }
}
