import 'package:support_local_artisans/core/error/failures.dart';
import 'package:support_local_artisans/features/register_view/domain/entities/RegisterResponseEntity.dart';


abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  Failures failures;
  RegisterErrorState({required this.failures});
}

class RegisterSuccessState extends RegisterStates {
  RegisterResponseEntity registerResponseEntity;
  RegisterSuccessState({required this.registerResponseEntity});
}
