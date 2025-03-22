import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

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
      dialogType: DialogType.success, // نوع الديالوج نجاح
      animType: AnimType.scale,
      width: 350,
      title: title,
      desc: message,
      btnOk: ElevatedButton.icon(
        onPressed: () {
          onButtonPressed!();
        },
        icon: const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
          size: 25,
        ),
        label: const Text("OK",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
      width: 350,
      title: title,
      desc: message,
      btnOk: ElevatedButton.icon(
        onPressed: () {
          Navigator.pop(context); // إغلاق الديالوج
        },
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white,
          size: 25,
        ),
        label: const Text("Retry",
            style: TextStyle(color: Colors.white, fontSize: 16)), // النص
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
      width: 400,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
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
