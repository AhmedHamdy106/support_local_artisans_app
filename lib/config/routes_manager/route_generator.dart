import 'package:flutter/material.dart';
import 'package:support_local_artisans/config/routes_manager/routes.dart';
import 'package:support_local_artisans/features/AccountScreen/AccountScreen.dart';
import 'package:support_local_artisans/features/CartScreen/CartScreen.dart';
import 'package:support_local_artisans/features/CategoriesScreen/CategoriesScreen.dart';
import 'package:support_local_artisans/features/Payment/PaymentScreen.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/home_screen_user.dart';
import 'package:support_local_artisans/features/login_view/presentation/pages/login_screen.dart';
import 'package:support_local_artisans/features/register_view/presentation/pages/register_screen.dart';
import '../../features/createNew_password_view/createnew_password_screen.dart';
import '../../features/forgot_pass_view/forgot_screen.dart';
import '../../features/home_view/presentation/details/product_details_screen.dart';
import '../../features/verification_code_view/verification_code_screen.dart';

class RouteGenerator {
  static Route<dynamic>? getRoute(RouteSettings settings) {
    switch (settings.name) {
      // case Routes.splashRoute:
      //   return MaterialPageRoute(builder: (_) => const SplashScreen(), settings: settings);
      case Routes.loginRoute:
        return MaterialPageRoute(
            builder: (_) => const LoginScreen(), settings: settings);
      case Routes.registerRoute:
        return MaterialPageRoute(
            builder: (_) => const RegisterScreen(), settings: settings);
      case Routes.homeRoute:
        return MaterialPageRoute(
            builder: (_) => HomeScreenUser(), settings: settings);
      case Routes.forgetPasswordRoute:
        return MaterialPageRoute(
            builder: (_) => const ForgetPasswordScreen(), settings: settings);
      case Routes.verificationCodeRoute:
        return MaterialPageRoute(
            builder: (_) => VerificationCodeScreen(), settings: settings);
      case Routes.createNewPasswordRoute:
        return MaterialPageRoute(
            builder: (_) => CreateNewPasswordScreen(token: ''),
            settings: settings);
      case Routes.cartRoute:
        return MaterialPageRoute(
            builder: (_) => CartScreen(), settings: settings);
      case Routes.categoriesRoute:
        return MaterialPageRoute(
            builder: (_) => CategoriesScreen(), settings: settings);
      case Routes.accountRoute:
        return MaterialPageRoute(
            builder: (_) => AccountScreen(), settings: settings);
      case Routes.productDetailsRoute:
        return MaterialPageRoute(
            builder: (_) => const ProductDetailsScreen(), settings: settings);
      case Routes.paymentRoute:
        return MaterialPageRoute(
            builder: (_) =>  PaymentScreen(), settings: settings);
      default:
        return _unDefinedRoute();
    }
  }

  static Route<dynamic> _unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text("No Route Found")),
        body: const Center(child: Text("No Route Found")),
      ),
    );
  }
}
