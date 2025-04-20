import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/shared/shared_preference.dart';
import '../../core/utils/app_colors.dart';
import '../home_view_user/presentation/pages/MainScreen.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  final String? token;
  const UserTypeSelectionScreen({super.key, this.token});

  @override
  _UserTypeSelectionScreenState createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  String? selectedUserType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Are you a seller or a client?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3B3B),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Choose the method that aligns with the\nservice you want.',
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
                    bc: AppColors.border,
                    type: 'client',
                    imagePath: 'assets/images/3.0x/Group_3.0x.png',
                  ),
                  SizedBox(width: 25.w),
                  _buildUserTypeCard(
                    bc: AppColors.border,
                    type: 'seller',
                    imagePath: 'assets/images/3.0x/Character_3.0x.png',
                  ),
                ],
              ),
              const SizedBox(height: 120),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedUserType != null
                      ? () async {
                          final isMerchant = selectedUserType == 'seller';
                          // حفظ قيمة التوكن
                          await SharedPreference.saveData(
                              key: "token", value: widget.token);
                          // حفظ قيمة الدور
                          await SharedPreference.saveData(
                              key: "role",
                              value: isMerchant ? "Artisan" : "User");

                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) =>
                                    MainScreen(isMerchant: isMerchant)),
                            (route) => false,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF774936),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
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
          color: isSelected ? const Color(0xFFEDD3CA) : bc,
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
                    type,
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
