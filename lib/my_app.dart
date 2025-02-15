import 'package:flutter/material.dart';
import 'config/routes_manager/route_generator.dart';

class MyApp extends StatelessWidget {
  final String? route;
  const MyApp({super.key, this.route});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) =>
          RouteGenerator.getRoute(settings),
      initialRoute: route,
    );
  }
}
