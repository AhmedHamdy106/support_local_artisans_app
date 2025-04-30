import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_local_artisans/core/api/api_manager.dart';
import 'package:support_local_artisans/core/api/end_points.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import '../../core/utils/custom_dialogs/success_dialog_glassmorphism.dart';
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
        showSuccessDialogGlass(context);
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
    final theme = Theme.of(context); // Get the current theme

    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor, // Use theme background color
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: theme.appBarTheme.backgroundColor, // Use app bar color from theme
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: theme.iconTheme.color, // Use icon color from theme
              size: 24.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.sp),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                Center(
                  child: Text(
                    'Create New Password',
                    style: TextStyle(
                      color: theme.textTheme.bodyLarge?.color, // Use text color from theme
                      fontFamily: "Roboto",
                      fontSize: 26.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Make sure your password is strong',
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color, // Use text color from theme
                        fontFamily: "Roboto",
                        fontSize: 16.sp,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100.h),
                const CustomLabelTextField(label: "New Password"),
                SizedBox(height: 5.h),
                CustomTextFormField(
                  prefixIcon:
                  Image.asset("assets/icons/3.0x/🦆 icon _lock_3.0x.png"),
                  hint: "Enter your New password",
                  keyboardType: TextInputType.text,
                  securedPassword: true,
                  validator: (text) => AppValidators.validatePassword(text),
                  controller: passwordController,
                ),
                SizedBox(height: 20.h),
                const CustomLabelTextField(label: "Confirm New Password"),
                SizedBox(height: 5.h),
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
                SizedBox(height: 80.h),
                _isLoading
                    ? Center(
                  child: SpinKitFadingCircle(
                    color: theme.primaryColor, // Use primary color from theme
                    size: 40.sp,
                  ),
                )
                    : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor, // Use primary color from theme
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await resetPassword();
                      }
                    },
                    child: Text(
                      'confirm',
                      style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.labelLarge?.color, // Use button text color from theme
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
