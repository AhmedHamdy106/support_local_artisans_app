import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/routes_manager/routes.dart';

void showSuccessDialogGlass(BuildContext context) {
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
            width: 0.75.sw,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.1), // Color for the background
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: colorScheme.surface.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20.r,
                  spreadRadius: 2.r,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Icon(
                    Icons.check_circle_outline,
                    color: colorScheme.primary, // Primary color for the icon
                    size: 60.sp,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Success",
                  style: GoogleFonts.roboto(
                    color: colorScheme.onSurface, // Text color from the theme
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Password has been changed successfully.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    color: colorScheme.onSurface.withOpacity(0.7), // Adjusted text color
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, Routes.loginRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary, // Primary color for the button
                    padding:
                    EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    "Ok",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary, // Text color on primary button
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return FadeTransition(
        opacity: anim1,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.elasticOut),
          child: child,
        ),
      );
    },
  );
}
