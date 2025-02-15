// سيتم إضافة شاشات Forgot Password هنا

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final Dio dio = Dio();

  Future<void> forgotPassword() async {
    const url = 'https://ecommerce.routemisr.com/api/v1/auth/forgotPasswords';
    try {
      final response = await dio.post(
        url,
        data: {"email": emailController.text.trim()},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      print(response.data); // ✅ اطبع الاستجابة

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data['message'])),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
      );
    } catch (e) {
      print("Error: $e"); // ✅ اطبع الخطأ لو حصل
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Enter your email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: forgotPassword,
              child: const Text("Send Reset Code"),
            ),
          ],
        ),
      ),
    );
  }
}

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Dio dio = Dio();

  Future<void> verifyResetCode() async {
    const url = 'https://ecommerce.routemisr.com/api/v1/auth/verifyResetCode';
    try {
      final response = await dio.post(
        url,
        data: {"resetCode": codeController.text.trim()},
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data['message'])),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error: $e")),
      );
    }
  }

  Future<void> resetPassword() async {
    const url = 'https://ecommerce.routemisr.com/api/v1/auth/resetPassword';
    try {
      final response = await dio.put(
        url,
        data: {
          "resetCode": codeController.text.trim(),
          "newPassword": passwordController.text.trim(),
        },
        options: Options(headers: {"Content-Type": "application/json"}),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data['message'])),
      );

      Navigator.pop(context); // الرجوع للشاشة السابقة بعد النجاح
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: "Enter Reset Code",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: verifyResetCode,
              child: const Text("Verify Code"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: "Enter New Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetPassword,
              child: const Text("Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}
