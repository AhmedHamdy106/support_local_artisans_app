import 'package:dartz/dartz.dart';
import 'package:support_local_artisans/features/login_view/domain/entities/LoginResponseEntity.dart';
import '../../../../../core/error/failures.dart';

abstract class LoginRemoteDataSource {
  Future<Either<LoginResponseEntity, Failures>> login(
    String email,
    String password,
    bool RememberMe,
  );
}
