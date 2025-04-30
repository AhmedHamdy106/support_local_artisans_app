import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:support_local_artisans/config/routes_manager/routes.dart';
import 'package:support_local_artisans/core/di/di.dart';
import 'package:support_local_artisans/core/shared/shared_preference.dart';
import 'package:support_local_artisans/features/register_view/presentation/manager/cubit/my_bloc_observer.dart';
import 'package:support_local_artisans/my_app.dart';
import 'package:support_local_artisans/features/home_view_user/presentation/pages/MainScreen.dart';
import 'config/themes/AppTheme.dart';
import 'config/themes/ThemeProvider.dart'; // استورد ملف الثيمات

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await SharedPreference.init();
  configureDependencies();

  String? token = SharedPreference.getData(key: "token");
  String? role = SharedPreference.getData(key: "role");

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(), // هنا دخلنا الProvider
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: token == null
                ? const MyApp(route: Routes.loginRoute)
                : MainScreen(isMerchant: role == "Artisan"),
          );
        },
      ),
    ),
  );
}