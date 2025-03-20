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
          child: Text(posButtonTitle,
              style: const TextStyle(fontFamily: "Roboto")),
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
          child: Text(negButtonTitle,
              style: const TextStyle(fontFamily: "Roboto")),
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
          return Transform.scale(
            scale: 0.80,
            child: AlertDialog(
              title: title != null
                  ? Row(
                      children: [
                        if (icon != null)
                          Icon(icon, color: iconColor, size: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  : null,
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: SingleChildScrollView(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: "Roboto",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              actions: actions,
            ),
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
          return Transform.scale(
            scale: 0.85, // تصغير حجم الديالوج
            child: AlertDialog(
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: "Roboto",
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
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
