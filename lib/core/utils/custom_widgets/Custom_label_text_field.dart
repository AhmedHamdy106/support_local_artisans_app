import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLabelTextField extends StatelessWidget {
  final String label;

  const CustomLabelTextField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Text(
      label,
      style: theme.textTheme.bodyLarge?.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        fontFamily: "Roboto",
        color: colorScheme.onSurface, // للحصول على اللون المناسب للنص حسب الثيم
      ),
    );
  }
}
