import 'package:flutter/material.dart';
import 'package:support_local_artisans/config/routes_manager/routes.dart';
import 'config/routes_manager/route_generator.dart';

class MyApp extends StatelessWidget {
  final String? route;
  const MyApp({super.key, this.route});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      initialRoute: Routes.splashRoute,
    );
  }
}
