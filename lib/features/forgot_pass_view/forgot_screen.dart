import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../config/routes_manager/routes.dart';
import '../../core/utils/custom_widgets/custom_text_form_field.dart';
import '../../core/utils/validators.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static final TextEditingController emailController = TextEditingController();

  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  late Animation<double> animation;
  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut)
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            controller.reverse();
          }
        },
      );
  }

  Future<void> sendForgetPasswordRequest() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xff8C4931)),
              SizedBox(width: 40),
              Text(
                "Please wait...",
                style: TextStyle(
                  color: Color(0xff0E0705),
                  fontFamily: "Roboto",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );

    try {
      Response response = await Dio().post(
        'http://abdoemam.runasp.net/api/Account/ForgetPassword',
        data: {'email': ForgetPasswordScreen.emailController.text.trim()},
      );

      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        // ✅ Success: Navigate to Verification Code Screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            animation: animation,
            behavior: SnackBarBehavior.floating,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Text(
              response.data['message'] ?? "A verification code has been sent to your email.",
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "Roboto",
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            duration: const Duration(seconds: 3),
          ),
        );

        // ✅ Navigate only if the request was successful
        Navigator.pushReplacementNamed(context, Routes.verificationCodeRoute);
      } else {
        // ❌ Email not registered or another error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            animation: animation,
            behavior: SnackBarBehavior.floating,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Text(
              response.data['message'] ,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: "Roboto",
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            duration: const Duration(seconds: 3),
          ),
        );

        // ❌ Do not navigate if there's an error
      }
    } catch (e) {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          animation: animation,
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: const Text(
          "This email is not registered. Please enter a valid email.",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Roboto",
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );

      // ❌ Do not navigate if there's an error
    }
  }



  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F0EC),
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: const Color(0xFFF8F0EC),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Forget Password',
                  style: TextStyle(
                    color: Color(0xff0E0705),
                    fontFamily: "Roboto",
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please enter your email and we send a confirmation code to your email.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Roboto",
                    color: Color(0xff9D9896),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 80),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Email Address',
                      style: TextStyle(
                        fontFamily: "Roboto",
                        color: Color(0xff0E0705),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                CustomTextFormField(
                  prefixIcon:
                      Image.asset("assets/icons/3.0x/🦆 icon _mail_3.0x.png"),
                  hint: "Enter your email",
                  keyboardType: TextInputType.text,
                  securedPassword: false,
                  validator: (text) => AppValidators.validateEmail(text),
                  controller: ForgetPasswordScreen.emailController,
                ),
                const SizedBox(height: 140),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff8C4931),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await sendForgetPasswordRequest();

                      }
                    },
                    child: const Text(
                      'send code',
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffEEEDEC),
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
