import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:support_local_artisans/features/register_view/presentation/manager/cubit/register_states.dart';
import '../../../../../core/shared/shared_preference.dart';
import '../../../domain/use_cases/register_use_case.dart';

@injectable
class RegisterScreenViewModel extends Cubit<RegisterStates> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  RegisterUseCase registerUseCase;

  RegisterScreenViewModel({required this.registerUseCase}) : super(RegisterInitialState());

  void register({required String role}) async {
    emit(RegisterLoadingState());
    var either = await registerUseCase.invoke(
      emailController.text,
      phoneController.text,
      nameController.text,
      role,
      passwordController.text,
      confirmPasswordController.text,
    );
    either.fold(
          (l) {
        emit(RegisterSuccessState(registerResponseEntity: l));
        print("Role from API: \${l.user?.role}");
      },
          (r) {
        emit(RegisterErrorState(failures: r));
      },
    );
  }

  /// التسجيل بعد اختيار الدور في شاشة الـ Selection
  Future<bool> registerFromSelection({
    required String? email,
    required String? phone,
    required String? name,
    required String? password,
    required String? confirmPassword,
    required String role,
  }) async {
    emit(RegisterLoadingState());

    var either = await registerUseCase.invoke(
      email ?? '',
      phone ?? '',
      name ?? '',
      role,
      password ?? '',
      confirmPassword ?? '',
    );

    bool success = true;

    either.fold(
          (l) async {
        // ✅ حفظ التوكن بعد نجاح العملية
        await SharedPreference.saveData(key: "token", value: l.token);
        await SharedPreference.saveData(key: "role", value: l.user?.role ?? role);

        emit(RegisterSuccessState(registerResponseEntity: l));
        await SharedPreference.getData(key: "token");
        await SharedPreference.getData(key: "role",);


        success = false;
      },
          (r) {
        emit(RegisterErrorState(failures: r));

      },
    );

    return success;

  }
}