import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:support_local_artisans/features/login_view/presentation/manager/cubit/login_states.dart';
import 'package:support_local_artisans/features/login_view/presentation/manager/cubit/login_view_model.dart';
import '../../../../config/routes_manager/routes.dart';
import '../../../../core/di/di.dart';
import '../../../../core/shared/shared_preference.dart';
import '../../../../core/utils/custom_widgets/custom_text_form_field.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../core/utils/validators.dart';
import '../../../forgot_pass_view/forgot_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final LoginScreenViewModel viewModel = getIt<LoginScreenViewModel>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isRememberMeChecked = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginScreenViewModel, LoginStates>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is LoginLoadingState) {
          DialogUtils.showLoadingDialog(context, message: "Waiting....");
        } else if (state is LoginErrorState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessageDialog(
            context: context,
            message: state.failures.errorMessage,
            posButtonTitle: "ok",
          );
        } else if (state is LoginSuccessState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessageDialog(
            context: context,
            message: "Login Successfully.",
            posButtonTitle: "Ok",
            posButtonAction: () {
              // todo : save token
              SharedPreference.saveData(
                  key: "token", value: state.responseEntity.token);
              print(state.responseEntity.token);
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.homeRoute,
                (route) => false,
              );
            },
          );
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
                          color: Color(0xff0E0705),
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
                          color: Color(0xff9D9896),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        color: Color(0xff0E0705),
                        fontFamily: "Roboto",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    CustomTextFormField(
                      prefixIcon: Image.asset(
                          "assets/icons/3.0x/🦆 icon _mail_3.0x.png"),
                      hint: "Enter your email",
                      keyboardType: TextInputType.text,
                      securedPassword: false,
                      validator: (text) {
                        if (text!.trim().isEmpty) {
                          return "This field is required";
                        }
                        return null;
                      },
                      controller: viewModel.emailController,
                    ),
                    const SizedBox(height: 30.0),
                    const Text(
                      'Password',
                      style: TextStyle(
                        color: Color(0xff0E0705),
                        fontFamily: "Roboto",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    CustomTextFormField(
                      prefixIcon: Image.asset(
                          "assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
                      hint: "Enter your password",
                      keyboardType: TextInputType.text,
                      securedPassword: true,
                      validator: (text) {
                        if (text!.trim().isEmpty) {
                          return "This field is required";
                        }
                        AppValidators.validatePassword(text);
                        return null;
                      },
                      controller: viewModel.passwordController,
                    ),
                    const SizedBox(height: 15.0),

                    /// إضافة Remember Me + Forget Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              activeColor: const Color(0xFF8C4931),
                              value: isRememberMeChecked,
                              onChanged: (value) {
                                setState(() {
                                  isRememberMeChecked = value ?? false;
                                });
                              },
                            ),
                            const Text("Remember Me"),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                       ForgetPasswordScreen()),
                            );
                          },
                          child: const Text(
                            'Forget password?',
                            style: TextStyle(
                                color: Color(0xFF8C4931),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // login();
                          if (formKey.currentState!.validate()) {
                            viewModel.login();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff8C4931),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffEEEDEC)),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF9D9896)),
                        ),
                        const SizedBox(width: 2),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.registerRoute);
                          },
                          child: Text(
                            "Sign Up",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontFamily: "Roboto",
                                  color: const Color(0xff8C4931),
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
