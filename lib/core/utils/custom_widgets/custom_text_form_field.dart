import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef Validator = String? Function(String? text);

class CustomTextFormField extends StatefulWidget {
  final String hint;
  final TextInputType keyboardType;
  final bool securedPassword;
  final Validator validator;
  final TextEditingController? controller;
  final Widget prefixIcon;

  const CustomTextFormField({
    super.key,
    required this.prefixIcon,
    required this.hint,
    required this.validator,
    this.keyboardType = TextInputType.text,
    this.securedPassword = true,
    this.controller,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormField();
}

class _CustomTextFormField extends State<CustomTextFormField> {
  late bool isVisibleText;

  @override
  void initState() {
    super.initState();
    isVisibleText = widget.securedPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16.sp),
      keyboardType: widget.keyboardType,
      obscureText: isVisibleText,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.all(10.r),
          child: SizedBox(width: 24.w, height: 24.h, child: widget.prefixIcon),
        ),
        errorMaxLines: 2,
        errorStyle: theme.textTheme.titleSmall?.copyWith(
          color: colorScheme.error,
          height: 1.2.h,
          fontSize: 16.sp,
        ),
        suffixIcon: widget.securedPassword
            ? InkWell(
          onTap: () {
            setState(() {
              isVisibleText = !isVisibleText;
            });
          },
          child: Icon(
            isVisibleText
                ? Icons.visibility_off_outlined
                : Icons.visibility,
            color: isVisibleText ? Colors.grey : colorScheme.primary,
            size: 25.sp,
          ),
        )
            : null,
        hintText: widget.hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        fillColor: theme.inputDecorationTheme.fillColor ?? colorScheme.surface,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colorScheme.error, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colorScheme.error, width: 1.w),
        ),
      ),
    );
  }
}