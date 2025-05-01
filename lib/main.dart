import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:support_local_artisans/config/routes_manager/routes.dart';
import 'package:support_local_artisans/core/di/di.dart';
import 'package:support_local_artisans/core/shared/shared_preference.dart';
import 'package:support_local_artisans/features/register_view/presentation/manager/cubit/my_bloc_observer.dart';
import 'config/routes_manager/route_generator.dart';
import 'config/themes/AppTheme.dart';
import 'config/themes/ThemeProvider.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await SharedPreference.init();
  configureDependencies();

  String? token = SharedPreference.getData(key: "token");
  String? role = SharedPreference.getData(key: "role");

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: context.locale, // ✅ مهم جداً
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              initialRoute:
                  token == null ? Routes.loginRoute : Routes.splashRoute,
              onGenerateRoute: (RouteSettings settings) {
                return RouteGenerator.getRoute(settings);
              },
            );
          },
        ),
      ),
    ),
  );
}
