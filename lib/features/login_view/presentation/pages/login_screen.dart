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
  const LoginScreen({super.key,  String? savedEmail,  String? savedPassword,  bool? rememberMe});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final LoginScreenViewModel viewModel = getIt<LoginScreenViewModel>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isRememberMeChecked = false;

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
          isRememberMeChecked = true;
        });
      }
    }
  }

  Future<void> saveLoginData(String email, String password, bool rememberMe) async {
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
            posButtonTitle: "OK",
          );
        } else if (state is LoginSuccessState) {
          DialogUtils.hideLoading(context);
          saveLoginData(viewModel.emailController.text, viewModel.passwordController.text, isRememberMeChecked);
          DialogUtils.showMessageDialog(
            context: context,
            message: "Login Successfully.",
            posButtonTitle: "Ok",
            posButtonAction: () {
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
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff9D9896),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text('Email Address'),
                    CustomTextFormField(
                      prefixIcon: Image.asset("assets/icons/3.0x/🦆 icon _mail_3.0x.png"),
                      hint: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      securedPassword: false,
                      validator: (text) => AppValidators.validateEmail(text),
                      controller: viewModel.emailController,
                    ),
                    const SizedBox(height: 30.0),
                    const Text('Password'),
                    CustomTextFormField(
                      prefixIcon: Image.asset("assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
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
                                  builder: (context) => ForgetPasswordScreen()),
                            );
                          },
                          child: const Text(
                            'Forget password?',
                            style: TextStyle(color: Color(0xFF8C4931)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          viewModel.login();
                        }
                      },
                      child: const Text('Log In'),
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
