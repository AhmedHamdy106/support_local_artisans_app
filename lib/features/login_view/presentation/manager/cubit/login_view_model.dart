import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:support_local_artisans/features/login_view/domain/use_cases/login_use_case.dart';
import 'package:support_local_artisans/features/login_view/presentation/manager/cubit/login_states.dart';

@injectable
class LoginScreenViewModel extends Cubit<LoginStates> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginUseCase? loginUseCase;

  bool _isLoggingIn = false; // ✅ متغير لمنع تنفيذ أكثر من طلب في نفس الوقت

  LoginScreenViewModel({this.loginUseCase}) : super(LoginInitialState());

  void login() async {
    if (_isLoggingIn) return; // ✅ منع تنفيذ دالة `login()` أكثر من مرة

    _isLoggingIn = true;
    emit(LoginLoadingState());

    var either = await loginUseCase?.invoke(
      emailController.text.trim(),
      passwordController.text.trim(),
      false,
    );

    either?.fold(
          (successResponse) {
        emit(LoginSuccessState(responseEntity: successResponse));
      },
          (failureResponse) {
        emit(LoginErrorState(failures: failureResponse));
      },
    );

    _isLoggingIn = false; // ✅ إعادة السماح بإرسال طلب جديد
  }
}
