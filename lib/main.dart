import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support_local_artisans/config/routes_manager/routes.dart';
import 'package:support_local_artisans/my_app.dart';
import 'core/di/di.dart';
import 'core/shared/shared_preference.dart';
import 'features/register_view/presentation/manager/cubit/my_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await SharedPreference.init();
  var token = SharedPreference.getData(key: "token");
  String? route;
  if (token == null) {
    route = Routes.loginRoute;
  } else {
    route = Routes.homeRoute;
    print("Token :  $token");
  }
  configureDependencies();
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MyApp(route: route);
      },
    ),
  );
}
