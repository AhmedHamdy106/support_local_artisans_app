import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import '../../core/utils/custom_widgets/custom_text_form_field.dart';
import '../../core/utils/validators.dart';
import '../verification_code_view/verification_code_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static final TextEditingController emailController = TextEditingController();

  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> sendForgetPasswordRequest() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SpinKitFadingCircle(
                    color: Colors.grey,
                    size: 40.sp,
                  ),
                  SizedBox(width: 20.w),
                  Text(
                    "Please wait...",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: "Roboto",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );

    try {
      var response = await Dio().post(
        'http://abdoemam.runasp.net/api/Account/ForgetPassword',
        data: {'email': ForgetPasswordScreen.emailController.text.trim()},
      );
      Navigator.of(context).pop();
      if (response.statusCode == 200) {
        Get.snackbar(
          "",
          "",
          titleText: Text(
            "Success",
            style: TextStyle(
              fontFamily: "Roboto",
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          messageText: Text(
            response.data['message'] ?? "OTP code has been sent to your email.",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          borderRadius: 12.r,
          margin: EdgeInsets.all(15.sp),
          duration: const Duration(seconds: 3),
          icon: Icon(
            Icons.check_circle_outline_outlined,
            color: Colors.black,
            size: 30.sp,
          ),
          forwardAnimationCurve: Curves.fastOutSlowIn,
          reverseAnimationCurve: Curves.easeIn,
        );
        Get.to(() => VerificationCodeScreen(),
            arguments: ForgetPasswordScreen.emailController.text.trim());
      } else {
        Get.snackbar(
          "",
          "",
          titleText: Text(
            "Error",
            style: TextStyle(
              fontFamily: "Roboto",
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          messageText: Text(
            response.data['message'] ??
                "Something went wrong, please try again.",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto",
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          borderRadius: 12.r,
          margin: EdgeInsets.all(15.sp),
          duration: const Duration(seconds: 3),
          icon: Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 30.sp,
          ),
          forwardAnimationCurve: Curves.fastOutSlowIn,
          reverseAnimationCurve: Curves.easeIn,
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      Get.snackbar(
        "",
        "",
        titleText: Text(
          "Error!",
          style: TextStyle(
            fontFamily: "Roboto",
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        messageText: Text(
          "This email is not registered. Please enter a valid email.",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Roboto",
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xffd9403d),
        borderRadius: 12.r,
        margin: EdgeInsets.all(15.sp),
        duration: const Duration(seconds: 3),
        icon: Icon(
          Icons.error_outline_outlined,
          color: Colors.white,
          size: 30.sp,
        ),
        forwardAnimationCurve: Curves.fastOutSlowIn,
        reverseAnimationCurve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.background,
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.sp),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Text(
                  'Forget Password',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontFamily: "Roboto",
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Please enter your email and we send a confirmation code to your email.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    color: AppColors.textSecondary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 80.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Email Address',
                      style: TextStyle(
                        fontFamily: "Roboto",
                        color: AppColors.textPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                CustomTextFormField(
                  prefixIcon:
                      Image.asset("assets/icons/3.0x/🦆 icon _mail_3.0x.png"),
                  hint: "Enter your email",
                  keyboardType: TextInputType.text,
                  securedPassword: false,
                  validator: (text) => AppValidators.validateEmail(text),
                  controller: ForgetPasswordScreen.emailController,
                ),
                SizedBox(height: 140.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await sendForgetPasswordRequest();
                      }
                    },
                    child: Text(
                      'send code',
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.buttonText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
