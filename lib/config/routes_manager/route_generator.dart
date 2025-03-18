import 'package:flutter/material.dart';
import 'package:support_local_artisans/config/routes_manager/routes.dart';
import 'package:support_local_artisans/features/login_view/presentation/pages/login_screen.dart';
import 'package:support_local_artisans/features/register_view/presentation/pages/register_screen.dart';
import 'package:support_local_artisans/features/splash_view/presentation/pages/splash_screen.dart';
import '../../features/createNew_password_view/createnew_password_screen.dart';
import '../../features/forgot_pass_view/forgot_screen.dart';
import '../../features/home_view/presentation/pages/home_screen.dart';
import '../../features/verification_code_view/verification_code_screen.dart';

class RouteGenerator {
  static Route<dynamic>? getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case Routes.loginRoute:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case Routes.registerRoute:
        return MaterialPageRoute(
          builder: (context) => const RegisterScreen(),
        );
      case Routes.homeRoute:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      case Routes.forgetPasswordRoute:
        return MaterialPageRoute(
          builder: (context) => const ForgetPasswordScreen(),
        );
      case Routes.verificationCodeRoute:
        return MaterialPageRoute(
          builder: (context) => VerificationCodeScreen(),
        );
      case Routes.createNewPasswordRoute:
        return MaterialPageRoute(
          builder: (context) => CreateNewPasswordScreen(token: '',),
        );
 efault:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            "No Route Found",
          ),
        ),
        body: const Center(
          child: Text("No Route Found"),
        ),
      ),
    );
  }
}
