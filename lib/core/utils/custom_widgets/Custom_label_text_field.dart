import 'package:flutter/material.dart';

class CustomLabelTextField extends StatelessWidget {
  final String label;

  const CustomLabelTextField({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xff0E0705),
        fontFamily: "Roboto",
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
