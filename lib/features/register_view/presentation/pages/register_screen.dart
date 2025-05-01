import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support_local_artisans/core/di/di.dart';
import 'package:support_local_artisans/core/utils/custom_widgets/custom_label_text_field.dart';
import 'package:support_local_artisans/core/utils/custom_widgets/custom_text_form_field.dart';
import 'package:support_local_artisans/core/utils/validators.dart';
import 'package:support_local_artisans/features/register_view/presentation/manager/cubit/register_view_model.dart';
import 'package:support_local_artisans/features/user_type_selection_screen/user_type_selection_screen.dart';
import '../../../../core/shared/shared_preference.dart';
import '../../../../config/routes_manager/routes.dart';
import 'package:easy_localization/easy_localization.dart'; // Import EasyLocalization

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
                          'create_account'.tr(), // Translate this string
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onBackground,
                          ),
                        ),
                        Text(
                          'create_account_subtitle'
                              .tr(), // Translate this string
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
                    child: CustomLabelTextField(
                        label: "full_name_label".tr()), // Translate this string
                  ),
                  SizedBox(height: 5.h),
                  CustomTextFormField(
                    prefixIcon: Image.asset(
                        "assets/icons/3.0x/🦆 icon _person_3.0x.png"),
                    hint: "full_name_hint".tr(), // Translate this string
                    keyboardType: TextInputType.text,
                    securedPassword: false,
                    validator: (text) => AppValidators.validateUsername(text),
                    controller: viewModel.nameController,
                  ),
                  SizedBox(height: 15.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomLabelTextField(
                        label:
                            "phone_number_label".tr()), // Translate this string
                  ),
                  SizedBox(height: 10.h),
                  CustomTextFormField(
                    hint: "phone_number_hint".tr(), // Translate this string
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
                    child: CustomLabelTextField(
                        label: "email_label".tr()), // Translate this string
                  ),
                  SizedBox(height: 5.h),
                  CustomTextFormField(
                    prefixIcon:
                        Image.asset("assets/icons/3.0x/🦆 icon _mail_3.0x.png"),
                    hint: "email_hint".tr(), // Translate this string
                    keyboardType: TextInputType.emailAddress,
                    securedPassword: false,
                    validator: (text) => AppValidators.validateEmail(text),
                    controller: viewModel.emailController,
                  ),
                  SizedBox(height: 15.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomLabelTextField(
                        label: "password_label".tr()), // Translate this string
                  ),
                  SizedBox(height: 5.h),
                  CustomTextFormField(
                    prefixIcon:
                        Image.asset("assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
                    hint: "password_hint".tr(), // Translate this string
                    keyboardType: TextInputType.text,
                    securedPassword: true,
                    validator: (text) => AppValidators.validatePassword(text),
                    controller: viewModel.passwordController,
                  ),
                  SizedBox(height: 15.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomLabelTextField(
                        label: "confirm_password_label"
                            .tr()), // Translate this string
                  ),
                  SizedBox(height: 5.h),
                  CustomTextFormField(
                    prefixIcon:
                        Image.asset("assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
                    hint: "confirm_password_hint".tr(), // Translate this string
                    keyboardType: TextInputType.text,
                    securedPassword: true,
                    validator: (text) {
                      if (text!.isEmpty || text.trim().isEmpty) {
                        return "confirm_password_required"
                            .tr(); // Translate this string
                      }
                      if (viewModel.passwordController.text != text) {
                        return "passwords_do_not_match"
                            .tr(); // Translate this string
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
                          backgroundColor: theme.primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          'sign_up'.tr(), // Translate this string
                          style: TextStyle(
                            fontFamily: "Roboto",
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
                        "already_have_account".tr(), // Translate this string
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
                          "log_in".tr(), // Translate this string
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: theme.primaryColor,
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
