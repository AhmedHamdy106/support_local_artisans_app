import 'package:dartz/dartz.dart';
import 'package:support_local_artisans/features/register_view/domain/entities/RegisterResponseEntity.dart';
import '../../../../../core/error/failures.dart';

abstract class RegisterRemoteDataSource {
  Future<Either<RegisterResponseEntity, Failures>> register(
    String name,
    String email,
    String password,
    String rePassword,
    String phone,
  );
}
