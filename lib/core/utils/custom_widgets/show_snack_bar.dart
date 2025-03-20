import 'package:flutter/material.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.snakebar,
      behavior: SnackBarBehavior.fixed,
      duration: const Duration(seconds: 2),
      content: Text(
        message,
        style:
            const TextStyle(color: AppColors.background, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
