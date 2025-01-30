import 'package:dartz/dartz.dart';
import 'package:support_local_artisans/core/error/failures.dart';
import 'package:support_local_artisans/features/login_view/domain/entities/LoginResponseEntity.dart';

abstract class LoginRepository {
  Future<Either<LoginResponseEntity, Failures>> login(
    String email,
    String password,
  );
}
