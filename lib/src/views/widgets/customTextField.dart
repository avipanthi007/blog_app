import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final bool? obsecureText;
  final Widget? prefix;
  final Widget? suffix;

  const CustomTextField(
      {super.key,
      this.controller,
      this.hintText,
      this.maxLines,
      this.maxLength,
      this.keyboardType,
      this.suffix,
      this.prefix,
      this.obsecureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter $hintText";
        }
      },
      maxLength: maxLength,
      keyboardType: keyboardType,
      obscureText: obsecureText ?? false,
      maxLines: obsecureText == true ? 1 : maxLines,
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          hintText: hintText,
          suffixIcon: suffix,
          prefixIcon: prefix),
    );
  }
}
