import 'package:flutter/material.dart';

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
    // TODO: implement initState
    isVisibleText = widget.securedPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      controller: widget.controller,
      style: const TextStyle(
        color: Colors.black,
      ),
      keyboardType: widget.keyboardType,
      obscureText: isVisibleText,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        errorStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.red,
            ),
        suffixIcon: widget.securedPassword
            ? InkWell(
                onTap: () {
                  setState(() {
                    isVisibleText = !isVisibleText;
                  });
                },
                child: isVisibleText
                    ? const Icon(
                        Icons.visibility_off_outlined,
                      )
                    : const Icon(
                        Icons.visibility,
                        color: Color(0xff8C4931),
                      ))
            : null,
        hintText: widget.hint,
        hintStyle: const TextStyle(
          color: Color(0xff9D9896),
          fontFamily: "Roboto",
          fontSize: 14,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
        ),
        fillColor: const Color(0xffF8F0EC),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xff8C4931)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
