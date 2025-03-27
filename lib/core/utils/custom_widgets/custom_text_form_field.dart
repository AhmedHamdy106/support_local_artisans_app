import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:support_local_artisans/core/utils/app_colors.dart';

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
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16.sp,
      ),
      keyboardType: widget.keyboardType,
      obscureText: isVisibleText,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.all(10.r),
          child: SizedBox(width: 24.w, height: 24.h, child: widget.prefixIcon),
        ),
        errorMaxLines: 2,
        errorStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.error,
              height: 1.2.h,
              fontSize: 16.sp,
              overflow: TextOverflow.visible,
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
                  color: isVisibleText ? Colors.grey : AppColors.primary,
                  size: 25.sp,
                ),
              )
            : null,
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: AppColors.textSecondary,
          fontFamily: "Roboto",
          fontSize: 14.sp,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
        ),
        fillColor: AppColors.background,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.textSecondary, width: 1.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.w),
        ),
      ),
    );
  }
}