import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  const LoginScreen(
      {super.key, String? savedEmail, String? savedPassword, bool? rememberMe});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final LoginScreenViewModel viewModel = getIt<LoginScreenViewModel>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool RememberMe = false;

  @override
  void initState() {
    super.initState();
    loadLoginData();
  }

  Future<void> loadLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool("remember_me") ?? false;

    if (rememberMe) {
      String? savedEmail = prefs.getString("email");
      String? savedPassword = prefs.getString("password");
      if (savedEmail != null && savedPassword != null) {
        setState(() {
          viewModel.emailController.text = savedEmail;
          viewModel.passwordController.text = savedPassword;
          rememberMe = true;
        });
      }
    }
  }

  Future<void> saveLoginData(
      String email, String password, bool rememberMe) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("remember_me", rememberMe);
    if (rememberMe) {
      await prefs.setString("email", email);
      await prefs.setString("password", password);
    } else {
      await prefs.remove("email");
      await prefs.remove("password");
    }
  }

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
                      keyboardType: TextInputType.emailAddress,
                      securedPassword: false,
                      validator: (text) => AppValidators.validateEmail(text),
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
                                activeColor: const Color(0xFF8C4931),
                                value: RememberMe,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    RememberMe = newValue ?? false;
                                  });
                                }),
                            const Text("Remember Me"),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgetPasswordScreen()),
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
