import 'package:flutter/material.dart';

class DialogUtils {
  static void showMessageDialog({
    required final BuildContext context,
    required final String message,
    final String? title,
    final String? posButtonTitle,
    final VoidCallback? posButtonAction,
    final String? negButtonTitle,
    final VoidCallback? negButtonAction,
    final bool isCancelable = true,
    final Color barrierColor = Colors.black54,
  }) {
    List<Widget> actions = [];
    if (posButtonTitle != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            posButtonAction?.call();
          },
          child: Text(posButtonTitle),
        ),
      );
    }
    if (negButtonTitle != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            negButtonAction?.call();
          },
          child: Text(negButtonTitle),
        ),
      );
    }
    showDialog(
      context: context,
      barrierDismissible: isCancelable,
      barrierColor: barrierColor,
      builder: (context) {
        return AlertDialog(
          title: title != null ? Text(title) : null,
          content: Text(message, style: const TextStyle(color: Colors.black)),
          actions: actions,
        );
      },
    );
  }

  static void showLoadingDialog(
      final BuildContext context, {
        required String message,
        bool isCancelable = false,
        final Color barrierColor = Colors.black54,
      }) {
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      return; // ✅ تجنب فتح أكثر من Dialog في نفس الوقت
    }

    showDialog(
      context: context,
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
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hideLoading(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
