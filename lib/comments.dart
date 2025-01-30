//https://ecommerce.routemisr.com

// {
// "name": "Abdulrahman",
// "email": "AbdulrahmanRoute@gmail.com",
// "password": "Abdo@123",
// "rePassword": "Abdo@123",
// "phone": "01552104885"
// }

// abstract class Failures {
//   String errorMessage;
//   Failures({required this.errorMessage});
// }
//
// class ServerError extends Failures {
//   ServerError({required super.errorMessage});
// }
//
// class NetworkError extends Failures {
//   NetworkError({required super.errorMessage});
// }

// import 'package:flutter/material.dart';
//
// class RegistrationPage extends StatefulWidget {
//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }
//
// class _RegistrationPageState extends State<RegistrationPage> {
//   final _formKey = GlobalKey<FormState>();
//   String _userType = 'عميل'; // نوع المستخدم الافتراضي
//   bool _isArtisan = false; // هل المستخدم حرفي؟
//
//   // Controllers لحقول الإدخال
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _workshopAddressController =
//       TextEditingController();
//   final TextEditingController _specializationController =
//       TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('تسجيل حساب جديد'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // اسم المستخدم
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'اسم المستخدم'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'يرجى إدخال اسم المستخدم';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               // البريد الإلكتروني/رقم الموبايل
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                     labelText: 'البريد الإلكتروني/رقم الموبايل'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'يرجى إدخال البريد الإلكتروني أو رقم الموبايل';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//
//               // كلمة المرور
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(labelText: 'كلمة المرور'),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.length < 6) {
//                     return 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//
//               // نوع المستخدم (عميل أو حرفي)
//               DropdownButtonFormField<String>(
//                 value: _userType,
//                 onChanged: (value) {
//                   setState(() {
//                     _userType = value!;
//                     _isArtisan = value == 'حرفي';
//                   });
//                 },
//                 items: ['عميل', 'حرفي'].map((type) {
//                   return DropdownMenuItem(
//                     value: type,
//                     child: Text(type),
//                   );
//                 }).toList(),
//                 decoration: InputDecoration(labelText: 'نوع المستخدم'),
//               ),
//               SizedBox(height: 16),
//
//               // الحقول الإضافية للحرفيين
//               if (_isArtisan) ...[
//                 // عنوان الورشة
//                 TextFormField(
//                   controller: _workshopAddressController,
//                   decoration: InputDecoration(labelText: 'عنوان الورشة'),
//                   validator: (value) {
//                     if (_isArtisan && (value == null || value.isEmpty)) {
//                       return 'يرجى إدخال عنوان الورشة';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),
//
//                 // التخصص
//                 TextFormField(
//                   controller: _specializationController,
//                   decoration: InputDecoration(labelText: 'التخصص'),
//                   validator: (value) {
//                     if (_isArtisan && (value == null || value.isEmpty)) {
//                       return 'يرجى إدخال التخصص';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16),
//               ],
//
//               // زر التسجيل
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     // معالجة البيانات وإرسالها إلى السيرفر
//                     print('اسم المستخدم: ${_nameController.text}');
//                     print('البريد الإلكتروني: ${_emailController.text}');
//                     print('نوع المستخدم: $_userType');
//                     if (_isArtisan) {
//                       print('عنوان الورشة: ${_workshopAddressController.text}');
//                       print('التخصص: ${_specializationController.text}');
//                     }
//                   }
//                 },
//                 child: Text('تسجيل'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
