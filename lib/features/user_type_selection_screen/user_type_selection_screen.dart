import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support_local_artisans/core/di/di.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';
import 'package:support_local_artisans/core/shared/shared_preference.dart';
import 'package:support_local_artisans/features/register_view/presentation/manager/cubit/register_view_model.dart';
import '../home_view_user/presentation/pages/MainScreen.dart';
import 'package:easy_localization/easy_localization.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  _UserTypeSelectionScreenState createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  String? selectedUserType;
  final viewModel = getIt<RegisterScreenViewModel>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 140,
                ),
                Text(
                  'are_you_seller_or_client'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'choose_service_type'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF786A6A),
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildUserTypeCard(
                      bc: colorScheme.onBackground.withOpacity(0.1),
                      type: 'client',
                      imagePath: 'assets/images/3.0x/Group_3.0x.png',
                    ),
                    SizedBox(width: 25.w),
                    _buildUserTypeCard(
                      bc: colorScheme.onBackground.withOpacity(0.1),
                      type: 'seller',
                      imagePath: 'assets/images/3.0x/Character_3.0x.png',
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedUserType != null
                        ? () async {
                            final isMerchant = selectedUserType == 'seller';
                            final role = isMerchant ? "Artisan" : "User";

                            // حفظ الدور
                            await SharedPreference.saveData(
                                key: "role", value: role);

                            // استدعاء البيانات من التخزين المؤقت
                            final name =
                                SharedPreference.getData(key: "temp_name");
                            final phone =
                                SharedPreference.getData(key: "temp_phone");
                            final email =
                                SharedPreference.getData(key: "temp_email");
                            final password =
                                SharedPreference.getData(key: "temp_password");
                            final confirmPassword = SharedPreference.getData(
                                key: "temp_confirmPassword");

                            // تنفيذ التسجيل عبر ViewModel
                            final result =
                                await viewModel.registerFromSelection(
                              name: name,
                              phone: phone,
                              email: email,
                              password: password,
                              confirmPassword:
                                  confirmPassword, // تأكيد كلمة المرور
                              role: role,
                            );

                            if (result) {
                              // استلام التوكن والدور بعد التسجيل
                              final token =
                                  await SharedPreference.getData(key: "token");
                              final role =
                                  await SharedPreference.getData(key: "role");
                              print("✅ Registration completed successfully.");
                              print("📦 token: $token");
                              print("🧑‍💼 role: $role");

                              // استخدم Navigator للتوجيه إلى الصفحة الرئيسية
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MainScreen(isMerchant: isMerchant),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('registration_failed'.tr()),
                                ),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'continue'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeCard({
    required String type,
    required String imagePath,
    required Color bc,
  }) {
    final bool isSelected = selectedUserType == type;
    return GestureDetector(
      onTap: () => setState(() => selectedUserType = type),
      child: Container(
        width: 159.w,
        height: 200.h,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : bc,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Align(
                  child: Radio<String>(
                    value: type,
                    groupValue: selectedUserType,
                    onChanged: (value) {
                      setState(() {
                        selectedUserType = value!;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 45.h, left: 7.w),
                  child: Text(
                    type.tr(),
                    style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Image.asset(imagePath, height: 175.h),
          ],
        ),
      ),
    );
  }
}
