import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:support_local_artisans/features/register_view/presentation/manager/cubit/register_states.dart';
import '../../../domain/use_cases/register_use_case.dart';

@injectable
class RegisterScreenViewModel extends Cubit<RegisterStates> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  RegisterUseCase registerUseCase;
  RegisterScreenViewModel({required this.registerUseCase})
      : super(RegisterInitialState());
  // hold data - handle logic
  void register() async {
    emit(RegisterLoadingState());
    var either = await registerUseCase.invoke(
      nameController.text,
      emailController.text,
      passwordController.text,
      confirmPasswordController.text,
      phoneController.text,
    );
    either.fold(
      (l) {
        emit(RegisterSuccessState(responseEntity: l));
      },
      (r) {
        emit(RegisterErrorState(failures: r));
      },
    );
  }
}
