import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../config/routes_manager/routes.dart';
import '../../core/utils/custom_widgets/custom_text_form_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
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
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });
  }

  // zezobode430@gmail.com
  // Abdoelnegm#0
  Future<void> sendForgetPasswordRequest() async {
    setState(() => isLoading = true);
    try {
      Response response = await Dio().post(
        'http://abdoemam.runasp.net/api/Account/ForgetPassword',
        data: {'email': emailController.text},
      );
      await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          animation: animation,
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Text(
            response.data['message'],
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "Roboto",
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pushReplacementNamed(context, Routes.verificationCodeRoute);
    } catch (e) {
      await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          animation: animation,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Text(
            'Error:  $e',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: "Roboto",
              fontSize: 16,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
            ),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
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
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Forget Password',
                  style: TextStyle(
                    color: Color(0xff0E0705),
                    fontFamily: "Roboto",
                    fontSize: 26,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Please enter your email and we send a',
                      style: TextStyle(
                        color: Color(0xff9D9896),
                        fontFamily: "Roboto",
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'confirmation code to your email.',
                      style: TextStyle(
                        color: Color(0xff9D9896),
                        fontFamily: "Roboto",
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Email Address',
                      style: TextStyle(
                        color: Color(0xff0E0705),
                        fontFamily: "Roboto",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                CustomTextFormField(
                  prefixIcon:
                      Image.asset("assets/icons/3.0x/🦆 icon _mail_3.0x.png"),
                  hint: "Enter your email",
                  keyboardType: TextInputType.emailAddress,
                  securedPassword: false,
                  validator: (text) {
                    if (text!.trim().isEmpty) {
                      return "This field is required";
                    }
                    return null;
                  },
                  controller: emailController,
                ),
                const SizedBox(height: 140),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff8C4931),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: isLoading ? null : sendForgetPasswordRequest,
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Color(0xff8C4931),
                          )
                        : const Text(
                            'send code',
                            style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                                color: Color(0xffEEEDEC)),
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
