import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:support_local_artisans/features/login_view/domain/use_cases/login_use_case.dart';
import 'package:support_local_artisans/features/login_view/presentation/manager/cubit/login_states.dart';

@injectable
class LoginScreenViewModel extends Cubit<LoginStates> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  LoginUseCase? loginUseCase;
  LoginScreenViewModel({this.loginUseCase}) : super(LoginInitialState());
  // hold data - handle logic
  void login() async {
    emit(LoginLoadingState());
    var either = await loginUseCase?.invoke(
      emailController.text,
      passwordController.text,
    );
    either?.fold(
      (l) {
        emit(LoginSuccessState(responseEntity: l));
      },
      (r) {
        emit(LoginErrorState(failures: r));
      },
    );
  }
}
