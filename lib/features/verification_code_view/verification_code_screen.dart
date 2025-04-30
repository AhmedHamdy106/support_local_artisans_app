import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import '../../config/routes_manager/routes.dart';
import '../../core/utils/custom_dialogs/show_custom_error.dart';
import '../../core/utils/custom_dialogs/show_custom_success.dart';
import '../forgot_pass_view/forgot_screen.dart';

class VerificationCodeScreen extends StatefulWidget {
  String? token;
  VerificationCodeScreen({super.key});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  String email = "";

  @override
  void initState() {
    super.initState();
    email = Get.arguments ?? "example@gmail.com";
  }

  Future<void> verifyOTP() async {
    if (otpController.text.isEmpty || otpController.text.length < 6) {
      showErrorDialog(
          context, "Invalid OTP!", "Please enter a valid OTP code.");
      return;
    }

    setState(() => isLoading = true);
    try {
      var response = await Dio().post(
        'http://abdoemam.runasp.net/api/Account/VerifyOTP',
        data: {'otp': otpController.text},
        options: Options(
          validateStatus: (status) => true,
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        setState(() => widget.token = response.data['token']);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", widget.token!);
        showCustomSuccessDialog(context, "Success", "OTP Verified.");
      } else {
        showErrorDialog(context, "Error", response.data['message']);
      }
    } catch (e) {
      showErrorDialog(context, "Error", e.toString());
    }
    setState(() => isLoading = false);
  }

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
                    "Waiting...",
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
              fontStyle: FontStyle.normal,
            ),
          ),
          messageText: Text(
            response.data['message'] ?? "OTP code has been sent to your email.",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ),
          ),
          snackPosition: SnackPosition.TOP, // يظهر من فوق
          backgroundColor: Colors.green,
          colorText: Colors.white,
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
        Navigator.pushReplacementNamed(context, Routes.verificationCodeRoute);
      }
    } catch (e) {
      Navigator.of(context).pop();
      Get.snackbar(
        "Error!",
        e.toString(),
        titleText: Text(
          e.toString(),
          style: TextStyle(
            fontFamily: "Roboto",
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.background,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              Text(
                'Enter Verification Code',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontFamily: "Roboto",
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal),
              ),
              SizedBox(height: 8.h),
              Text(
                'We have sent an OTP code to your email',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: "Roboto",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 8.h),
              Text(
                email,
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontFamily: "Roboto",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 60.h),
              SizedBox(
                width: double.infinity,
                child: OtpTextField(
                  disabledBorderColor: const Color(0xff9D9896),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  borderRadius: BorderRadius.circular(4.r),
                  focusedBorderColor: AppColors.primary,
                  clearText: true,
                  enabledBorderColor: AppColors.textSecondary,
                  numberOfFields: 6,
                  borderColor: AppColors.textPrimary,
                  cursorColor: AppColors.textPrimary,
                  keyboardType: TextInputType.number,
                  showFieldAsBox: true,
                  onSubmit: (String verificationCode) {
                    setState(
                          () {
                        otpController.text = verificationCode;
                      },
                    );
                  }, // end onSubmit
                ),
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
                    await verifyOTP();
                  },
                  child: Text(
                    'verify code',
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.background),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn’t received code?",
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(width: 1.w),
                  TextButton(
                    onPressed: () async {
                      await sendForgetPasswordRequest();
                    },
                    child: Text(
                      "send again",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontFamily: "Roboto",
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
