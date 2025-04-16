import 'package:flutter/material.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit profile'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome, Mohamed',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'mohamed.N@gmail.com',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24.0),
            _buildTextField(
              labelText: 'Your full name',
              initialValue: 'Mohamed Mohamed Nabil',
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              labelText: 'Your E-mail',
              initialValue: 'mohamed.N@gmail.com',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              labelText: 'Your password',
              initialValue: '*',
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              labelText: 'Your mobile number',
              initialValue: '01122118855',
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            _buildTextField(
              labelText: 'Your Address',
              initialValue: '6th October, street 11.....',
              maxLines: null,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Implement save functionality
                print('تم حفظ التغييرات');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'save changes',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String labelText,
    String? initialValue,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () {
                // Implement edit functionality
                print('تم الضغط على زر التعديل لحقل $labelText');
              },
            ),
          ),
        ),
      ],
    );
  }
}