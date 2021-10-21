import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText, hintText;
  final Icon? prefixIcon;
  final FormFieldValidator<String>? validator;
  final bool? obscureText;

  const CustomTextFormField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.prefixIcon,
    this.validator,
    this.obscureText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(),
        ),
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon ?? const SizedBox(),
      ),
      obscureText: obscureText ?? false,
      validator: validator,
    );
  }
}
