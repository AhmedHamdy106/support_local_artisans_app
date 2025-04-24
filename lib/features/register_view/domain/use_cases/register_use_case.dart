import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:support_local_artisans/features/register_view/domain/repositories/register_repository.dart';
import '../../../../core/error/failures.dart';
import '../entities/RegisterResponseEntity.dart';

@injectable
class RegisterUseCase {
  RegisterRepository registerRepository;
  RegisterUseCase({required this.registerRepository});

  Future<Either<RegisterResponseEntity, Failures>> invoke(
    String email,
    String phoneNumber,
    String displayName,
    String role,
    String password,
    String confirmedPassword,
  ) {
    return registerRepository.register(
        email, phoneNumber, displayName, role, password, confirmedPassword);
  }
}
