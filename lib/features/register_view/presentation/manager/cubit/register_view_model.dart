import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:support_local_artisans/features/register_view/presentation/manager/cubit/register_states.dart';
import '../../../domain/use_cases/register_use_case.dart';

@injectable
class RegisterScreenViewModel extends Cubit<RegisterStates> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  RegisterUseCase registerUseCase;
  RegisterScreenViewModel({required this.registerUseCase})
      : super(RegisterInitialState());
  void register({required String Role}) async {
    emit(RegisterLoadingState());
    var either = await registerUseCase.invoke(
      emailController.text,
      phoneController.text,
      nameController.text,
      Role,
      passwordController.text,
      confirmPasswordController.text,
    );
    either.fold(
      (l) {
        emit(RegisterSuccessState(registerResponseEntity: l));
      },
      (r) {
        emit(RegisterErrorState(failures: r));
      },
    );
  }
}
