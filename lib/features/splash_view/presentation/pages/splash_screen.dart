import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_local_artisans/features/login_view/presentation/pages/login_screen.dart'; // استبدل بالمسار الصحيح لملف تسجيل الدخول

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadLoginData(); // ✅ تحميل بيانات تسجيل الدخول عند فتح التطبيق
  }

  Future<void> loadLoginData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool("remember_me") ?? false;

    if (rememberMe) {
      String? savedEmail = prefs.getString("email");
      String? savedPassword = prefs.getString("password");

      if (savedEmail != null && savedPassword != null) {
        // ✅ الانتقال إلى صفحة تسجيل الدخول وملء البيانات المحفوظة
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(
              savedEmail: savedEmail,
              savedPassword: savedPassword,
              rememberMe: true,
            ),
          ),
        );
        return;
      }
    }

    // ✅ إذا لم يكن هناك بيانات محفوظة، انتقل مباشرةً إلى شاشة تسجيل الدخول
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // شاشة تحميل مؤقتة
      ),
    );
  }
}
