import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/routes_manager/routes.dart';
import '../../../features/verification_code_view/verification_code_screen.dart';

void showCustomSuccessDialog(
    BuildContext context, String title, String message) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 0.6.sw,
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: colorScheme.background,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.onBackground.withOpacity(0.1),
                  blurRadius: 20.r,
                  spreadRadius: 2.r,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline_outlined,
                  color: colorScheme.primary,
                  size: 50.sp,
                ),
                SizedBox(height: 15.h),
                Text(
                  title,
                  style: TextStyle(
                      color: colorScheme.onBackground,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onBackground.withOpacity(0.7),
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(
                      context,
                      Routes.createNewPasswordRoute,
                      arguments: VerificationCodeScreen().token,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    "Ok",
                    style: TextStyle(color: colorScheme.onPrimary, fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: anim1, curve: Curves.easeInOut),
        child: child,
      );
    },
  );
}
