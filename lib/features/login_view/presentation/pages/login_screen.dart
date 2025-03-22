import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/core/utils/custom_widgets/Custom_label_text_field.dart';
import 'package:support_local_artisans/core/utils/dialogs.dart';
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
      listener: (context, state) {
        if (state is LoginLoadingState) {
          print("Login started...");
          DialogUtils.showLoadingDialog(context: context, title: "Logging...");
        } else if (state is LoginErrorState) {
          print("Login failed: ${state.failures.errorMessage}");
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
          print("Login successful");
          DialogUtils.hideLoadingDialog();
          // تأكد من إغلاق أي Dialog مفتوح قبل التنقل
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          SharedPreference.saveData(
              key: "token", value: state.responseEntity.token);
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.homeRoute, (route) => false);
        }
      },
      child: Form(
        key: formKey,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F0EC),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    const Center(
                      child: Text(
                        'Welcome Back👋',
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'Please enter your email and password to log in.',
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const CustomLabelTextField(label: "Email Address"),
                    CustomTextFormField(
                      prefixIcon: const Icon(Icons.email,
                          color: AppColors.textSecondary),
                      hint: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      securedPassword: false,
                      validator: (text) => AppValidators.validateEmail(text),
                      controller: viewModel.emailController,
                    ),
                    const SizedBox(height: 30.0),
                    const CustomLabelTextField(label: "Password"),
                    CustomTextFormField(
                      prefixIcon: const Icon(Icons.lock,
                          color: AppColors.textSecondary),
                      hint: "Enter your password",
                      keyboardType: TextInputType.text,
                      securedPassword: true,
                      validator: (text) => AppValidators.validatePassword(text),
                      controller: viewModel.passwordController,
                    ),
                    const SizedBox(height: 15.0),
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
                            const Text(
                              "Remember Me",
                              style: TextStyle(
                                  color: AppColors.textPrimary, fontSize: 14),
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
                          child: const Text(
                            'Forget password?',
                            style: TextStyle(
                                color: AppColors.primary, fontFamily: "Roboto"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.buttonText),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
                                ),
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
