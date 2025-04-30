import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support_local_artisans/core/di/di.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/core/utils/custom_widgets/custom_label_text_field.dart';
import 'package:support_local_artisans/core/utils/custom_widgets/custom_text_form_field.dart';
import 'package:support_local_artisans/core/utils/validators.dart';
import 'package:support_local_artisans/features/register_view/presentation/manager/cubit/register_view_model.dart';
import 'package:support_local_artisans/features/user_type_selection_screen/user_type_selection_screen.dart';
import '../../../../core/shared/shared_preference.dart';
import '../../../../config/routes_manager/routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterScreenViewModel viewModel = getIt<RegisterScreenViewModel>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 50.h),
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onBackground,
                          ),
                        ),
                        Text(
                          'create an account to start your journey.',
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            color: colorScheme.onBackground.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const CustomLabelTextField(label: "Full Name"),
                  ),
                  SizedBox(height: 5.h),
                  CustomTextFormField(
                    prefixIcon: Image.asset(
                        "assets/icons/3.0x/🦆 icon _person_3.0x.png"),
                    hint: "Enter your full name",
                    keyboardType: TextInputType.text,
                    securedPassword: false,
                    validator: (text) => AppValidators.validateUsername(text),
                    controller: viewModel.nameController,
                  ),
                  SizedBox(height: 15.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const CustomLabelTextField(label: "Phone Number"),
                  ),
                  SizedBox(height: 10.h),
                  CustomTextFormField(
                    hint: "Enter phone number",
                    keyboardType: TextInputType.number,
                    securedPassword: false,
                    validator: (text) =>
                        AppValidators.validatePhoneNumber(text),
                    controller: viewModel.phoneController,
                    prefixIcon: Icon(
                      Icons.local_phone_outlined,
                      color: colorScheme.onBackground,
                      size: 25.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const CustomLabelTextField(label: "Email Address"),
                  ),
                  SizedBox(height: 5.h),
                  CustomTextFormField(
                    prefixIcon:
                    Image.asset("assets/icons/3.0x/🦆 icon _mail_3.0x.png"),
                    hint: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    securedPassword: false,
                    validator: (text) => AppValidators.validateEmail(text),
                    controller: viewModel.emailController,
                  ),
                  SizedBox(height: 15.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const CustomLabelTextField(label: "Password"),
                  ),
                  SizedBox(height: 5.h),
                  CustomTextFormField(
                    prefixIcon:
                    Image.asset("assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
                    hint: "Enter your password",
                    keyboardType: TextInputType.text,
                    securedPassword: true,
                    validator: (text) => AppValidators.validatePassword(text),
                    controller: viewModel.passwordController,
                  ),
                  SizedBox(height: 15.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child:
                    const CustomLabelTextField(label: "Confirm Password"),
                  ),
                  SizedBox(height: 5.h),
                  CustomTextFormField(
                    prefixIcon:
                    Image.asset("assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
                    hint: "Enter confirmPassword",
                    keyboardType: TextInputType.text,
                    securedPassword: true,
                    validator: (text) {
                      if (text!.isEmpty || text.trim().isEmpty) {
                        return "Confirm Password is required";
                      }
                      if (viewModel.passwordController.text != text) {
                        return "Passwords don't match";
                      }
                      return null;
                    },
                    controller: viewModel.confirmPasswordController,
                  ),
                  SizedBox(height: 40.h),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await SharedPreference.saveData(
                                key: "temp_name",
                                value: viewModel.nameController.text);
                            await SharedPreference.saveData(
                                key: "temp_phone",
                                value: viewModel.phoneController.text);
                            await SharedPreference.saveData(
                                key: "temp_email",
                                value: viewModel.emailController.text);
                            await SharedPreference.saveData(
                                key: "temp_password",
                                value: viewModel.passwordController.text);
                            await SharedPreference.saveData(
                                key: "temp_confirmPassword",
                                value:
                                viewModel.confirmPasswordController.text);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const UserTypeSelectionScreen(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: colorScheme.onBackground.withOpacity(0.7)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.loginRoute);
                        },
                        child: Text(
                          "Log In",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
