import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
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
  const LoginScreen({super.key,  String? savedEmail , String? savedPassword,bool? rememberMe}) ;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final LoginScreenViewModel viewModel = getIt<LoginScreenViewModel>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool rememberMe = false;

  // @override
  // void initState() {
  //   super.initState();
  //   loadLoginData();
  // }

  // Future<void> loadLoginData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool savedRememberMe = prefs.getBool("remember_me") ?? false;
  //   if (savedRememberMe) {
  //     setState(() {
  //       viewModel.emailController.text = prefs.getString("email") ?? "";
  //       viewModel.passwordController.text = prefs.getString("password") ?? "";
  //       rememberMe = savedRememberMe;
  //     });
  //   }
  // }
  //
  // Future<void> saveLoginData(String email, String password, bool remember) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool("remember_me", remember);
  //   if (remember) {
  //     await prefs.setString("email", email);
  //     await prefs.setString("password", password);
  //   } else {
  //     await prefs.remove("email");
  //     await prefs.remove("password");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginScreenViewModel, LoginStates>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is LoginLoadingState) {
          DialogUtils.showLoadingDialog(context, message: "Logging in...");
        } else if (state is LoginErrorState) {
          DialogUtils.hideLoading(context);
          DialogUtils.showMessageDialog(
            context: context,
            title: "Login Failed",
            message: state.failures.errorMessage,
            posButtonTitle: "OK",
          );
        } else if (state is LoginSuccessState) {
          DialogUtils.hideLoading(context);
          // saveLoginData(viewModel.emailController.text, viewModel.passwordController.text, rememberMe);
          DialogUtils.showMessageDialog(
            context: context,
            title: "Success",
            message: "Login Successfully!",
            posButtonTitle: "OK",
            posButtonAction: () {
              SharedPreference.saveData(key: "token", value: state.responseEntity.token);
              Navigator.pushNamedAndRemoveUntil(context, Routes.homeRoute, (route) => false);
            },
          );
        }
      },
      child: Form(
        key: formKey,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    Center(
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
                    const Text('Email Address'),
                    CustomTextFormField(
                      prefixIcon: Icon(Icons.email, color: AppColors.textSecondary),
                      hint: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      securedPassword: false,
                      validator: (text) => AppValidators.validateEmail(text),
                      controller: viewModel.emailController,
                    ),
                    const SizedBox(height: 30.0),
                    const Text('Password'),
                    CustomTextFormField(
                      prefixIcon: Icon(Icons.lock, color: AppColors.textSecondary),
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
                            const Text("Remember Me"),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()));
                          },
                          child: const Text(
                            'Forget password?',
                            style: TextStyle(color: AppColors.primary),
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
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.buttonText),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, Routes.registerRoute),
                          child: const Text("Sign Up", style: TextStyle(color: AppColors.primary)),
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
