import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:support_local_artisans/features/login_view/domain/entities/LoginResponseEntity.dart';
import 'package:support_local_artisans/features/login_view/domain/repositories/login_repository.dart';
import '../../../../core/error/failures.dart';

@injectable
class LoginUseCase {
  LoginRepository loginRepository;
  LoginUseCase({required this.loginRepository});

  Future<Either<LoginResponseEntity, Failures>> invoke(
    String email,
    String password,
    bool RememberMe,
  ) {
    return loginRepository.login(email, password, RememberMe);
  }
}
