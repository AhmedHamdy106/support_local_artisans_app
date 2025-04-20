import 'package:get/get.dart';
import 'package:support_local_artisans/core/shared/shared_preference.dart';
import 'package:support_local_artisans/features/login_view/presentation/pages/login_screen.dart';

Future<void> logout() async {
  await SharedPreference.removeData(key: "token");
  await SharedPreference.removeData(key: "role");

  Get.offAll(() => const LoginScreen());
}
