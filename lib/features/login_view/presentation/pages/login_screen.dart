import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get_core/src/get_main.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/core/utils/custom_widgets/Custom_label_text_field.dart';
import 'package:support_local_artisans/core/utils/dialogs.dart';
import 'package:support_local_artisans/features/home_view/presentation/pages/home_screen.dart';
import 'package:support_local_artisans/features/login_view/presentation/manager/cubit/login_states.dart';
import 'package:support_local_artisans/features/login_view/presentation/manager/cubit/login_view_model.dart';
import '../../../../config/routes_manager/routes.dart';
import '../../../../core/di/di.dart';
import '../../../../core/shared/shared_preference.dart';
import '../../../../core/utils/custom_widgets/custom_text_form_field.dart';
import '../../../../core/utils/validators.dart';
import '../../../forgot_pass_view/forgot_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen(
      {super.key, String? savedEmail, String? savedPassword, bool? rememberMe});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final LoginScreenViewModel viewModel = getIt<LoginScreenViewModel>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginScreenViewModel, LoginStates>(
      bloc: viewModel,
      listener: (context, state) async {
        if (state is LoginLoadingState) {
          DialogUtils.showLoadingDialog(context: context, title: "Logging...");
        } else if (state is LoginErrorState) {
          DialogUtils.hideLoadingDialog();
          DialogUtils.showErrorDialog(
            context: context,
            title: "An error occurred during the login process!",
            message: state.failures.errorMessage,
            buttonText: "try again",
            onRetryPressed: () {
              DialogUtils.hideLoadingDialog();
            },
          );
        } else if (state is LoginSuccessState) {
          DialogUtils.hideLoadingDialog();
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          await SharedPreference.saveData(
              key: "token", value: state.responseEntity.token);
          Get.offAll( HomeScreen(),
              transition: getx.Transition.leftToRightWithFade,
              duration: const Duration(milliseconds: 500));
        }
      },
      child: Form(
        key: formKey,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F0EC),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 40.h),
                    Center(
                      child: Text(
                        'Welcome Back👋',
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Please enter your email and password to log in.',
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 14.sp,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    SizedBox(height: 80.h),
                    const CustomLabelTextField(label: "Email Address"),
                    CustomTextFormField(
                      prefixIcon: Image.asset(
                          "assets/icons/3.0x/🦆 icon _mail_3.0x.png"),
                      hint: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      securedPassword: false,
                      validator: (text) => AppValidators.validateEmail(text),
                      controller: viewModel.emailController,
                    ),
                    SizedBox(height: 20.h),
                    const CustomLabelTextField(label: "Password"),
                    CustomTextFormField(
                      prefixIcon: Image.asset(
                          "assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
                      hint: "Enter your password",
                      keyboardType: TextInputType.text,
                      securedPassword: true,
                      validator: (text) => AppValidators.validatePassword(text),
                      controller: viewModel.passwordController,
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              activeColor: AppColors.primary,
                              value: rememberMe,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  rememberMe = newValue ?? false;
                                });
                              },
                            ),
                            Text(
                              "Remember Me",
                              style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14.sp,
                                  fontFamily: "Roboto",
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgetPasswordScreen()));
                          },
                          child: Text(
                            'Forget password?',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 14.sp,
                                fontFamily: "Roboto",
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 80.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            viewModel.login();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          'log in',
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                              color: AppColors.buttonText,
                              fontFamily: "Roboto"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w500,
                              fontSize: 16.sp,
                              fontStyle: FontStyle.normal,
                              color: AppColors.textSecondary),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, Routes.registerRoute),
                          child: Text(
                            "sign up",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontFamily: "Roboto",
                                    color: AppColors.primary,
                                    fontSize: 16.sp,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
