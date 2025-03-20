import 'package:flutter/material.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';

class CustomLabelTextField extends StatelessWidget {
  final String label;

  const CustomLabelTextField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontFamily: "Roboto",
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
