import 'package:flutter/material.dart';
import 'package:support_local_artisans/core/shared/shared_preference.dart';
import 'package:support_local_artisans/features/login_view/presentation/pages/login_screen.dart';

Future<void> logout(BuildContext context) async {
  try {
    // إزالة التوكن والدور من SharedPreferences
    await SharedPreference.removeData(key: "token");
    await SharedPreference.removeData(key: "role");

    // الانتقال إلى شاشة تسجيل الدخول
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false, // إزالة جميع الشاشات السابقة
    );
  } catch (error) {
    // التعامل مع أي استثناء قد يحدث أثناء عملية الخروج
    print("Logout error: $error");
    // عرض التنبيه للمستخدم في حالة حدوث خطأ أثناء الخروج
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('An error occurred while logging out')),
    );
  }
}
