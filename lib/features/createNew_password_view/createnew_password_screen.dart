import 'package:flutter/material.dart';
import '../../core/utils/custom_widgets/Custom_label_text_field.dart';
import '../../core/utils/custom_widgets/custom_text_form_field.dart';
import '../../core/utils/validators.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Center(
                  child: Text(
                    'Create New Password',
                    style: TextStyle(
                      color: Color(0xff0E0705),
                      fontFamily: "Roboto",
                      fontSize: 26,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Make sure your password  is strong',
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
                const SizedBox(height: 100),
                const CustomLabelTextField(label: "New Password"),
                const SizedBox(
                  height: 5,
                ),
                CustomTextFormField(
                  prefixIcon:
                      Image.asset("assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
                  hint: "Enter your  New password",
                  keyboardType: TextInputType.text,
                  securedPassword: true,
                  validator: (text) {
                    if (text!.trim().isEmpty) {
                      return "this field is required";
                    }
                    AppValidators.validatePassword(text);
                    return null;
                  },
                  controller: passwordController,
                ),
                const SizedBox(
                  height: 20,
                ),
                const CustomLabelTextField(label: "Confirm New Password"),
                const SizedBox(
                  height: 5,
                ),
                CustomTextFormField(
                  prefixIcon:
                      Image.asset("assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
                  hint: "Enter your New password",
                  keyboardType: TextInputType.text,
                  securedPassword: true,
                  validator: (text) {
                    if (text!.isEmpty) {
                      if (text.trim().isEmpty) {
                        return "this field is required";
                      }
                      return "Please enter password";
                    }
                    if (passwordController.text != text) {
                      return "Password doesn't match";
                    }
                    return null;
                  },
                  controller: confirmPasswordController,
                ),
                const SizedBox(height: 80),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff8C4931),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => VerificationCodeScreen()),
                      // );
                    },
                    child: const Text(
                      'confirm',
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
