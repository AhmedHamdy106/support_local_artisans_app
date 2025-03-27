import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'config/routes_manager/route_generator.dart';

class MyApp extends StatelessWidget {
  final String? route;
  const MyApp({super.key, this.route});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
      onGenerateRoute: (RouteSettings settings) =>
          RouteGenerator.getRoute(settings),
      initialRoute: route,
    );
  }
}
