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
          backgroundColor: const Color(0xFFF8F0EC), // Blue background
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    const Center(
                      child: Text(
                        'Welcome Back👋',
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 24,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff0E0705),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'please enter your email and password to log in.',
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 14,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff9D9896),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        color: Color(0xff0E0705),
                        fontFamily: "Roboto",
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
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
                          return "this field is required";
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
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextFormField(
                      prefixIcon: Image.asset(
                          "assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
                      hint: "Enter your password",
                      keyboardType: TextInputType.text,
                      securedPassword: true,
                      validator: (text) {
                        if (text!.trim().isEmpty) {
                          return "this field is required";
                        }
                        AppValidators.validatePassword(text);
                        return null;
                      },
                      controller: viewModel.passwordController,
                    ),
                    const SizedBox(height: 15.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen()),
                          );
                        },
                        child: const Text(
                          'Forget password?',
                          style: TextStyle(
                              color: Color(0xFF8C4931),
                              fontFamily: "Roboto",
                              fontStyle: FontStyle.normal,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
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
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'log in',
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 20,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffEEEDEC)),
                        ),
                      ),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // login();
                    //     if (formKey.currentState!.validate()) {
                    //       viewModel.login();
                    //     }
                    //     // if (viewModel.passwordController.text ==
                    //     //     ForgotPasswordScreen.newPasswordController.text) {
                    //     //   viewModel.login();
                    //     //}
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.white,
                    //     foregroundColor: const Color(0xFF003B84),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10.0),
                    //     ),
                    //   ),
                    //   child: const Padding(
                    //     padding: EdgeInsets.symmetric(vertical: 15.0),
                    //     child: Text(
                    //       'Log in',
                    //       style: TextStyle(
                    //         color: Color(0xff012e2f),
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 40.0),
                    // Center(
                    //   child: RichText(
                    //     text: const TextSpan(
                    //       text: "Don't have an account? ",
                    //       style: TextStyle(color: Colors.black),
                    //       children: [
                    //         TextSpan(
                    //           text: 'sign up',
                    //           style: TextStyle(
                    //               color: Colors.brown, fontWeight: FontWeight.bold),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
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
                        const SizedBox(
                          width: 2,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.registerRoute);
                          },
                          child: Text(
                            "sign up",
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
