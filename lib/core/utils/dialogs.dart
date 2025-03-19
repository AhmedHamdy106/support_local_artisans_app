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
            title: title != null ? Text(title) : null,
            content: Text(
              message,
              style: const TextStyle(color: Colors.black, fontFamily: "Roboto"),
            ),
            actions: actions,
          );
        },
      );
    }
  }

  static void showLoadingDialog(
      final BuildContext context, {
        required String message,
        bool isCancelable = false,
        final Color barrierColor = Colors.black54,
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
                      style: const TextStyle(color: Colors.black, fontFamily: "Roboto"),
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
