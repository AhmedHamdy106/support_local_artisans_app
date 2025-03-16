import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../createNew_password_view/createnew_password_screen.dart';

class VerificationCodeScreen extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();

  VerificationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                'Enter Verification Code',
                style: TextStyle(
                  color: Color(0xff0E0705),
                  fontFamily: "Roboto",
                  fontSize: 26,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We have send an OTP code to your email',
                style: TextStyle(
                  color: Color(0xff9D9896),
                  fontFamily: "Roboto",
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "example@gmail.com",
                style: TextStyle(
                  color: Color(0xff0E0705),
                  fontFamily: "Roboto",
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 60),
              OtpTextField(
                focusedBorderColor: const Color(0xff8C4931),
                clearText: true,
                enabledBorderColor: const Color(0xff9D9896),
                numberOfFields: 6,
                borderColor: Colors.black,
                cursorColor: Colors.black,
                keyboardType: TextInputType.number,
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Verification Code"),
                          content: Text('Code entered is $verificationCode'),
                        );
                      });
                }, // end onSubmit
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
                          builder: (context) =>
                              const CreateNewPasswordScreen()),
                    );
                  },
                  child: const Text(
                    'continue',
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontStyle: FontStyle.normal,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xffEEEDEC)),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn’t received code?",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 16,
                      color: Color(0xFF9D9896),
                    ),
                  ),
                  const SizedBox(width: 1),
                  TextButton(
                    onPressed: () {
                      //Navigator.pushNamed(context, Routes.registerRoute);
                    },
                    child: Text(
                      "send again",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontFamily: "Roboto",
                            color: const Color(0xff8C4931),
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
