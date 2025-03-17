import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import '../../config/routes_manager/routes.dart';

class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({super.key});

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  String? token;
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> verifyOTP() async {
    if (otpController.text.isEmpty || otpController.text.length < 6) {
      await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          animation: animation,
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: const Text(
            "Please enter a valid OTP code",
            style: TextStyle(
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
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Please enter a valid OTP code")),
      // );
      return;
    }

    setState(() => isLoading = true);
    try {
      Response response = await Dio().post(
        'http://abdoemam.runasp.net/api/Account/VerifyOTP',
        data: {'otp': otpController.text},
        options: Options(
          validateStatus: (status) => true,
          headers: {'Content-Type': 'application/json'},
        ),
      );
      if (response.statusCode == 200) {
        setState(() => token = response.data['token']);
        await ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            animation: animation,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
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
        Navigator.pushReplacementNamed(
          context,
          Routes.createNewPasswordRoute,
          arguments: token!,
        );
      } else {
        await ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            animation: animation,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
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
      }
    } catch (e) {
      await ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          animation: animation,
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.all(16),
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
                showFieldAsBox: true,
                onSubmit: (String verificationCode) {
                  setState(() {
                    otpController.text = verificationCode;
                  });
                }, // end onSubmit
              ),
              const SizedBox(height: 140),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff8C4931),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: isLoading ? null : verifyOTP,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Color(0xff8C4931),
                        )
                      : const Text(
                          'Verify code',
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
