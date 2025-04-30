import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLabelTextField extends StatelessWidget {
  final String label;

  const CustomLabelTextField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        fontFamily: "Roboto",
      ),
    );
  }
}