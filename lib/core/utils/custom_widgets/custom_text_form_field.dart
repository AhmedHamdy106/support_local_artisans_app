import 'package:flutter/material.dart';
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
      style: const TextStyle(
        color: AppColors.textPrimary,
      ),
      keyboardType: widget.keyboardType,
      obscureText: isVisibleText,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        errorMaxLines: 2,
        // ✅ السماح بظهور الخطأ على سطرين أو أكثر
        errorStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.error,
              height: 1.2, // ✅ تحسين المسافة بين الأسطر
              fontSize: 16, // ✅ تصغير حجم الخط قليلاً إذا لزم الأمر
              overflow: TextOverflow.visible, // ✅ التأكد من عرض كل النص
            ),
        suffixIcon: widget.securedPassword
            ? InkWell(
                onTap: () {
                  setState(() {
                    isVisibleText = !isVisibleText;
                  });
                },
                child: isVisibleText
                    ? const Icon(Icons.visibility_off_outlined)
                    : const Icon(Icons.visibility, color: AppColors.primary),
              )
            : null,
        hintText: widget.hint,
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontFamily: "Roboto",
          fontSize: 14,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
        ),
        fillColor: AppColors.background,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.textSecondary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
