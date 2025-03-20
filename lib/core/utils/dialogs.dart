import 'package:flutter/material.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';

class DialogUtils {
  static void showMessageDialog({
    required BuildContext context,
    required String message,
    String? title,
    String? posButtonTitle,
    VoidCallback? posButtonAction,
    String? negButtonTitle,
    VoidCallback? negButtonAction,
    bool isCancelable = true,
    Color barrierColor = Colors.transparent,
    Color? iconColor,
    IconData? icon,
  }) {
    List<Widget> actions = [];
    if (posButtonTitle != null) {
      actions.add(
        TextButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            posButtonAction?.call();
          },
          child: Text(posButtonTitle, style: const TextStyle(fontFamily: "Roboto")),
        ),
      );
    }
    if (negButtonTitle != null) {
      actions.add(
        TextButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            negButtonAction?.call();
          },
          child: Text(negButtonTitle, style: const TextStyle(fontFamily: "Roboto")),
        ),
      );
    }

    if (context.mounted) {
      showDialog(
        context: context,
        useRootNavigator: true,
        barrierDismissible: isCancelable,
        barrierColor: barrierColor,
        builder: (context) {
          return AlertDialog(
            title: title != null
                ? Row(
              children: [
                if (icon != null) Icon(icon, color: iconColor, size: 28),
                const SizedBox(width: 8),
                Text(title),
              ],
            )
                : null,
            content: Text(
              message,
              style: const TextStyle(color: AppColors.textPrimary, fontFamily: "Roboto"),
            ),
            actions: actions,
          );
        },
      );
    }
  }

  static void showLoadingDialog(
      BuildContext context, {
        required String message,
        bool isCancelable = false,
        Color barrierColor = Colors.transparent,
      }) {
    if (context.mounted) {
      showDialog(
        context: context,
        useRootNavigator: true,
        barrierDismissible: isCancelable,
        barrierColor: barrierColor,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => isCancelable,
            child: AlertDialog(
              content: Row(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(color: AppColors.textPrimary, fontFamily: "Roboto"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  static void hideLoading(BuildContext context) {
    if (context.mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
