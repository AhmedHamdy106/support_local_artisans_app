import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogUtils {
  static AwesomeDialog? _loadingDialog;

  static void showSuccessDialog({
    required BuildContext context,
    required String message,
    String title = 'Success',
    String buttonText = 'Ok',
    VoidCallback? onButtonPressed,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      width: 350.w,
      title: title,
      desc: message,
      btnOk: ElevatedButton.icon(
        onPressed: () {
          onButtonPressed!();
        },
        icon: Icon(
          Icons.check_circle_outline,
          color: Colors.white,
          size: 25.sp,
        ),
        label:
            Text("OK", style: TextStyle(color: Colors.white, fontSize: 16.sp)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        ),
      ),
    ).show();
  }

  static void showErrorDialog({
    required BuildContext context,
    required String message,
    String title = 'Error',
    String buttonText = 'Retry',
    VoidCallback? onRetryPressed,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      width: 350.w,
      title: title,
      desc: message,
      btnOk: ElevatedButton.icon(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.error_outline,
          color: Colors.white,
          size: 25.sp,
        ),
        label: Text("Retry",
            style: TextStyle(color: Colors.white, fontSize: 16.sp)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        ),
      ),
    ).show();
  }

  static void showLoadingDialog({
    required BuildContext context,
    String title = 'Loading...',
  }) {
    _loadingDialog = AwesomeDialog(
      context: context,
      width: 300.w,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SpinKitFadingCircle(
                color: Colors.grey,
                size: 40.sp,
              ),
              SizedBox(width: 20.w),
              Text(
                title,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    )..show();
  }

  static void hideLoadingDialog() {
    if (_loadingDialog != null) {
      _loadingDialog!.dismiss();
      _loadingDialog = null;
    }
  }
}
