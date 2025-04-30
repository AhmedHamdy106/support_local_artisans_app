import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support_local_artisans/core/utils/custom_widgets/custom_label_text_field.dart';
import 'package:support_local_artisans/core/utils/dialogs.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/MainScreen.dart';
import 'package:support_local_artisans/features/login_view/presentation/manager/cubit/login_states.dart';
import 'package:support_local_artisans/features/login_view/presentation/manager/cubit/login_view_model.dart';
import '../../../../config/routes_manager/routes.dart';
import '../../../../core/di/di.dart';
import '../../../../core/shared/shared_preference.dart';
import '../../../../core/utils/custom_widgets/custom_text_form_field.dart';
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
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme
    final colorScheme = theme.colorScheme; // Access the color scheme

    return BlocListener<LoginScreenViewModel, LoginStates>(
      bloc: viewModel,
      listener: (context, state) async {
        if (state is LoginLoadingState) {
          DialogUtils.showLoadingDialog(context: context, title: "Logging...");
        } else if (state is LoginSuccessState) {
          DialogUtils.hideLoadingDialog();
          final token = state.responseEntity.token;
          final role = state.responseEntity.user?.role ?? "User";
          final isMerchant = role == "Artisan";

          await SharedPreference.saveData(key: "token", value: token);
          await SharedPreference.saveData(key: "role", value: role);

          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(isMerchant: isMerchant),
              ),
                  (route) => false,
            );
          }
        } else if (state is LoginErrorState) {
          DialogUtils.hideLoadingDialog();
          DialogUtils.showErrorDialog(
            title: "Login Failed",
            context: context,
            message: state.failures.errorMessage,
            buttonText: "Retry",
            onRetryPressed: () => Navigator.of(context).pop(),
          );
        }
      },
      child: Form(
        key: formKey,
        child: Scaffold(
          backgroundColor: colorScheme.background, // Use background color from theme
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
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onBackground, // Use onBackground color for text
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Please enter your email and password to log in.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          color: colorScheme.onBackground, // Use onBackground color for text
                        ),
                      ),
                    ),
                    SizedBox(height: 80.h),
                    const CustomLabelTextField(label: "Email Address"),
                    CustomTextFormField(
                      prefixIcon: Image.asset("assets/icons/3.0x/🦆 icon _mail_3.0x.png"),
                      hint: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      securedPassword: false,
                      validator: (text) => AppValidators.validateEmail(text),
                      controller: viewModel.emailController,
                    ),
                    SizedBox(height: 20.h),
                    const CustomLabelTextField(label: "Password"),
                    CustomTextFormField(
                      prefixIcon: Image.asset("assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
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
                              activeColor: colorScheme.primary, // Use primary color from theme
                              value: rememberMe,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  rememberMe = newValue ?? false;
                                });
                              },
                            ),
                            Text(
                              "Remember Me",
                              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14.sp, color: colorScheme.onBackground), // Use onBackground color for text
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgetPasswordScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Forget password?',
                            style: TextStyle(
                              color: colorScheme.primary, // Use primary color from theme
                              fontSize: 14.sp,
                            ),
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
                          backgroundColor: colorScheme.primary, // Use primary color from theme
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          'Log In',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 20.sp,
                            color: colorScheme.onPrimary, // Use onPrimary color for text
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16.sp, color: colorScheme.onBackground), // Use onBackground color for text
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, Routes.registerRoute),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: colorScheme.primary, // Use primary color from theme
                              fontWeight: FontWeight.w500,
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
