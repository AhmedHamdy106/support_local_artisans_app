import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support_local_artisans/config/routes_manager/routes.dart';
import 'package:support_local_artisans/core/shared/shared_preference.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "support Local Artisans",
          style: TextStyle(color: Colors.white, fontFamily: "Roboto"),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            // todo : remove token
            // todo : navigate to loginScreen
            SharedPreference.removeData(key: "token");
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.loginRoute,
              (route) => false,
            );
          },
          icon: Icon(
            Icons.logout,
            color: Colors.white,
            size: 25.sp,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Text(
          "Home Screen",
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
