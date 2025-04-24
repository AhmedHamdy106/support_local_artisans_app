import 'package:dartz/dartz.dart';
import 'package:support_local_artisans/features/register_view/domain/entities/RegisterResponseEntity.dart';
import '../../../../../core/error/failures.dart';

abstract class RegisterRemoteDataSource {
  Future<Either<RegisterResponseEntity, Failures>> register(
    String email,
    String phoneNumber,
    String displayName,
    String role,
    String password,
    String confirmedPassword,
  );
}
