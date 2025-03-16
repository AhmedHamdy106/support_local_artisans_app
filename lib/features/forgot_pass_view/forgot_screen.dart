import 'package:flutter/material.dart';
import '../../core/di/di.dart';
import '../../core/utils/custom_widgets/custom_text_form_field.dart';
import '../login_view/presentation/manager/cubit/login_view_model.dart';
import '../verification_code_view/verification_code_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  static final LoginScreenViewModel viewModel = getIt<LoginScreenViewModel>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
                  hint: "Enter your mail",
                  keyboardType: TextInputType.text,
                  securedPassword: false,
                  validator: (text) {
                    if (text!.trim().isEmpty) {
                      return "This field is required";
                    }
                    return null;
                  },
                  controller: viewModel.emailController,
                ),
                const SizedBox(height: 140),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff8C4931),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerificationCodeScreen()),
                      );
                    },
                    child: const Text(
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
