import 'package:flutter/material.dart';
import 'package:support_local_artisans/config/routes_manager/routes.dart';
import 'package:support_local_artisans/core/shared/shared_preference.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "support Local Artisans",
          style: TextStyle(color: Colors.white),
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
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xff00796b),
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          "Home Screen",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
