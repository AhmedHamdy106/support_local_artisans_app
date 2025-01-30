import 'package:support_local_artisans/core/error/failures.dart';
import 'package:support_local_artisans/features/login_view/domain/entities/LoginResponseEntity.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginErrorState extends LoginStates {
  Failures failures;
  LoginErrorState({required this.failures});
}

class LoginSuccessState extends LoginStates {
  LoginResponseEntity responseEntity;
  LoginSuccessState({required this.responseEntity});
}
