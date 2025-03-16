import 'package:dartz/dartz.dart';
import 'package:support_local_artisans/core/error/failures.dart';
import 'package:support_local_artisans/features/register_view/domain/entities/RegisterResponseEntity.dart';

abstract class RegisterRepository {
  Future<Either<RegisterResponseEntity, Failures>> register(
    String email,
    String phoneNumber,
    String displayname,
    String Role,
    String password,
    String confirmedPassword,
  );
}
