import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_local_artisans/core/api/api_manager.dart';
import 'package:support_local_artisans/core/api/end_points.dart';

import '../../config/routes_manager/routes.dart';
import '../../core/utils/custom_widgets/Custom_label_text_field.dart';
import '../../core/utils/custom_widgets/custom_text_form_field.dart';
import '../../core/utils/validators.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  late final String token;
  CreateNewPasswordScreen({Key? key, required this.token}) : super(key: key);

  @override
  _CreateNewPasswordScreenState createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  String? _savedToken;

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedToken = prefs.getString("auth_token");

    if (savedToken != null) {
      setState(() {
        _savedToken = savedToken;
      });
      print("Token Loaded Successfully: $_savedToken");
    } else {
      print("No Token Found!");
    }
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Success"),
          content: const Text(
            "Password has been changed successfully.",
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, Routes.loginRoute);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> resetPassword() async {
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    if (_savedToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Error: No valid token found. Please try logging in again.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      var response = await ApiManager.putData(
        EndPoints.resetPasswordEndPoint,
        body: {
          "password": passwordController.text,
          "ConfirmPassword": confirmPasswordController.text,
        },
        headers: {
          "Authorization": "Bearer $_savedToken",
          "Content-Type": "application/json",
        },
      );

      print("Response Status: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reset password: ${response.data}')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
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
                  validator: (text) => AppValidators.validatePassword(text),
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
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Color(0xff8C4931),
                      ))
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff8C4931),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await resetPassword();
                            }
                          },
                          child: const Text(
                            'confirm',
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
