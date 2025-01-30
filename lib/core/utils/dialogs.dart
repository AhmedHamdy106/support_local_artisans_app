import 'package:flutter/material.dart';

class DialogUtils {
  static void showMessageDialog({
    required final BuildContext context,
    required final String message,
    final String? posButtonTitle,
    final VoidCallback? posButtonAction,
    final String? negButtonTitle,
    final VoidCallback? negButtonAction,
    final bool isCancelable = true,
  }) {
    List<Widget> actions = [];
    if (posButtonTitle != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            posButtonAction?.call();
          },
          child: Text(
            posButtonTitle,
          ),
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
          child: Text(
            negButtonTitle,
          ),
        ),
      );
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
            actions: actions,
          );
        },
        barrierDismissible: isCancelable);
  }

  static void showLoadingDialog(
    final BuildContext context, {
    required String message,
    bool isCancelable = true,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(
              width: 12,
            ),
            Text(
              message,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ));
      },
      barrierDismissible: isCancelable,
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }
}
