import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SpinKitFadingCircle(
                    color: Theme.of(context).primaryColor,
                    size: 40.sp,
                  ),
                  SizedBox(width: 20.w),
                  Text(
                    "please_wait".tr(),
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Row(
              children: [
                Icon(Icons.check_circle_outline_outlined,
                    color: Colors.white, size: 30.sp),
                SizedBox(width: 10.w),
                Expanded(
                    child: Text(response.data['message'] ?? "otp_sent".tr())),
              ],
            ),
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(15.sp),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodeScreen(),
            settings: RouteSettings(
              arguments: ForgetPasswordScreen.emailController.text.trim(),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white, size: 30.sp),
                SizedBox(width: 10.w),
                Expanded(
                    child: Text(
                        response.data['message'] ?? "something_wrong".tr())),
              ],
            ),
            duration: const Duration(seconds: 3),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r)),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(15.sp),
          ),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xffd9403d),
          content: Row(
            children: [
              Icon(Icons.error_outline_outlined,
                  color: Colors.white, size: 30.sp),
              SizedBox(width: 10.w),
              Expanded(child: Text("email_not_registered".tr())),
            ],
          ),
          duration: const Duration(seconds: 3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(15.sp),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: theme.appBarTheme.backgroundColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.iconTheme.color,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.sp),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 40.h),
                Text(
                  "forget_password".tr(),
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge?.color,
                    fontFamily: "Roboto",
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "forget_password_description".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    color: theme.textTheme.bodyMedium?.color,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 80.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "email_address".tr(),
                      style: TextStyle(
                        fontFamily: "Roboto",
                        color: theme.textTheme.bodyLarge?.color,
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
                  hint: "enter_email".tr(),
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
                      backgroundColor: theme.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await sendForgetPasswordRequest();
                      }
                    },
                    child: Text(
                      "send_code".tr(),
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.labelLarge?.color,
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
