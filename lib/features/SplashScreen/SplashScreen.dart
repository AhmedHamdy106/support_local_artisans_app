import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:support_local_artisans/core/shared/shared_preference.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/MainScreen.dart';
import 'package:support_local_artisans/features/login_view/presentation/pages/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1700),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _logoController.forward();

    // بعد الانيميشن نبدأ التحقق من التوكن
    Future.delayed(const Duration(seconds: 3), () {
      checkLoginStatus();
    });
  }

  Future<void> checkLoginStatus() async {
    final token = await SharedPreference.getData(key: "token");
    final role = await SharedPreference.getData(key: "role");

    if (token != null && role != null) {
      if (JwtDecoder.isExpired(token)) {
        // إذا كان التوكن منتهي الصلاحية، ننتقل إلى شاشة تسجيل الدخول
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        // إذا كان التوكن صالحًا، ننتقل إلى الصفحة الرئيسية بناءً على الدور
        final isMerchant = role == "Artisan";
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(isMerchant: isMerchant),
          ),
        );
      }
    } else {
      // إذا لم يوجد توكن، ننتقل إلى شاشة تسجيل الدخول
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/logo.jpg", height: 120), // ضع اللوجو هنا
              const SizedBox(height: 20),
              const Text(
                "Support Local Artisans",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
