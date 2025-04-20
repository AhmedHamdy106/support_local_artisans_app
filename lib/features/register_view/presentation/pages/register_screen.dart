import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as getx;
import 'package:support_local_artisans/core/di/di.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/core/utils/custom_widgets/custom_label_text_field.dart';
import 'package:support_local_artisans/core/utils/custom_widgets/custom_text_form_field.dart';
import 'package:support_local_artisans/core/utils/dialogs.dart';
import 'package:support_local_artisans/core/utils/validators.dart';
import 'package:support_local_artisans/features/register_view/presentation/manager/cubit/register_states.dart';
import '../../../../config/routes_manager/routes.dart';
import '../../../../core/shared/shared_preference.dart';
import '../../../user_type_selection_screen/user_type_selection_screen.dart';
import '../manager/cubit/register_view_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterScreenViewModel viewModel = getIt<RegisterScreenViewModel>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedUserType = 'client';

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterScreenViewModel, RegisterStates>(
      bloc: viewModel,
      listener: (context, state) async {
        if (state is RegisterLoadingState) {
          DialogUtils.showLoadingDialog(context: context, title: "Loading....");
        } else if (state is RegisterErrorState) {
          DialogUtils.hideLoadingDialog();
          DialogUtils.showErrorDialog(
            title: "An error occurred while creating the account!",
            context: context,
            message: state.failures.errorMessage,
            buttonText: "try again",
            onRetryPressed: () {
              DialogUtils.hideLoadingDialog();
            },
          );
        } else if (state is RegisterSuccessState) {
          DialogUtils.hideLoadingDialog();
          await SharedPreference.saveData(
              key: "token", value: state.registerResponseEntity.token);
          // حفظ قيمة الدور هنا
          await SharedPreference.saveData(
              key: "role",
              value: selectedUserType == "client" ? "User" : "Artisan");
          DialogUtils.showSuccessDialog(
            context: context,
            title: "Success",
            message: "Registration successful",
            buttonText: "Ok",
            onButtonPressed: () {
              getx.Get.to(
                () => UserTypeSelectionScreen(
                  token: state.registerResponseEntity.token!,
                ),
                transition: getx.Transition.downToUp,
                duration: const Duration(milliseconds: 800),
              );
            },
          );
        }
      },
      child: Form(
        key: formKey,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.background,
          body: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 100.h,
                          ),
                          Text(
                            'Create Account',
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 24.sp,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'create an account to start your journey.',
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 16.sp,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    const CustomLabelTextField(label: "Full Name"),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomTextFormField(
                      prefixIcon: Image.asset(
                          "assets/icons/3.0x/🦆 icon _person_3.0x.png"),
                      hint: "Enter your full name",
                      keyboardType: TextInputType.text,
                      securedPassword: false,
                      validator: (text) => AppValidators.validateUsername(text),
                      controller: viewModel.nameController,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    const CustomLabelTextField(label: "Phone Number"),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomTextFormField(
                      hint: "Enter phone number",
                      keyboardType: TextInputType.number,
                      securedPassword: false,
                      validator: (text) =>
                          AppValidators.validatePhoneNumber(text),
                      controller: viewModel.phoneController,
                      prefixIcon: Icon(
                        Icons.local_phone_outlined,
                        color: AppColors.textSecondary,
                        size: 25.sp,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    const CustomLabelTextField(label: "Email Address"),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomTextFormField(
                      prefixIcon: Image.asset(
                          "assets/icons/3.0x/🦆 icon _mail_3.0x.png"),
                      hint: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      securedPassword: false,
                      validator: (text) => AppValidators.validateEmail(text),
                      controller: viewModel.emailController,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    const CustomLabelTextField(label: "Password"),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomTextFormField(
                      prefixIcon: Image.asset(
                          "assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
                      hint: "Enter your password",
                      keyboardType: TextInputType.text,
                      securedPassword: true,
                      validator: (text) => AppValidators.validatePassword(text),
                      controller: viewModel.passwordController,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    const CustomLabelTextField(label: "Confirm Password"),
                    SizedBox(
                      height: 5.h,
                    ),
                    CustomTextFormField(
                      prefixIcon: Image.asset(
                          "assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
                      hint: "Enter confirmPassword",
                      keyboardType: TextInputType.text,
                      securedPassword: true,
                      validator: (text) {
                        if (text!.isEmpty) {
                          if (text.trim().isEmpty) {
                            return "confirmPassword is required";
                          }
                          return "confirmPassword is required";
                        }
                        if (viewModel.passwordController.text != text) {
                          return "Password doesn't match";
                        }
                        return null;
                      },
                      controller: viewModel.confirmPasswordController,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              String roleToSend = selectedUserType == "client"
                                  ? "User"
                                  : "Artisan";
                              viewModel.register(Role: roleToSend);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            'sign up',
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 20.sp,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                              color: AppColors.buttonText,
                            ),
                          ),
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
                          "Already have an account?",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                              color: AppColors.textSecondary),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.loginRoute);
                          },
                          child: Text(
                            "log in",
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
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeCard(String type, String imagePath,
      {required Color bc}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUserType = type;
        });
      },
      child: Container(
        width: 159.w,
        height: 200.h,
        decoration: BoxDecoration(
          color: selectedUserType == type ? const Color(0xFFEDD3CA) : bc,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Align(
                  child: Radio<String>(
                    value: type,
                    groupValue: selectedUserType,
                    onChanged: (value) {
                      setState(() {
                        selectedUserType = value!;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 45.h, left: 7.w),
                  child: Text(
                    type,
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 20.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Image.asset(imagePath, height: 175.h),
          ],
        ),
      ),
    );
  }
}
