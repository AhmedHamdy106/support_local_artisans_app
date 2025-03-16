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
  Future<Either<RegisterResponseEntity, Failures>> register(
    String email,
    String phoneNumber,
    String displayname,
    String Role,
    String password,
    String confirmedPassword,
  ) async {
    var either = await registerRemoteDataSource.register(
        email, phoneNumber, displayname, Role, password, confirmedPassword);
    return either.fold(
      (response) => Left(response),
      (error) => Right(error),
    );
  }
}
