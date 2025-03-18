import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_local_artisans/core/api/api_manager.dart';
import 'package:support_local_artisans/core/api/end_points.dart';

class CreateNewPasswordScreen extends StatefulWidget {
    late final String token;
   CreateNewPasswordScreen({Key? key, required this.token}) : super(key: key);

  @override
  _CreateNewPasswordScreenState createState() => _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _savedToken; // ✅ متغير لحفظ التوكين بعد استرجاعه

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
    getToken(); // ✅ استرجاع التوكين عند فتح الشاشة
  }

  Future<void> resetPassword() async {
    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    if (_savedToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: No valid token found. Please try logging in again.')),
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
          "password": _passwordController.text,
          "ConfirmPassword": _confirmPasswordController.text, // ✅ السيرفر يحتاجه
        },
        headers: {
          "Authorization": "Bearer $_savedToken",
          "Content-Type": "application/json",
        },
      );

      print("Response Status: ${response.statusCode}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset successful')),
        );
        Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(title: Text('Create New Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'New Password'),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Confirm Password'),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: resetPassword,
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
