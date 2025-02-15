import 'package:flutter/material.dart';

typedef Validator = String? Function(String? text);

class CustomTextFormField extends StatefulWidget {
  final String hint;
  final TextInputType keyboardType;
  final bool securedPassword;
  final Validator validator;
  final TextEditingController? controller;

  const CustomTextFormField({
    super.key,
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
                    ? const Icon(Icons.visibility_off_outlined)
                    : const Icon(Icons.visibility))
            : null,
        hintText: widget.hint,
        hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Colors.black,
            ),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
