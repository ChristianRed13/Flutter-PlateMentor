import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String hintText;
  final String? Function(String?) validator;
  final TextEditingController controller;
  final TextInputType textInputType;
  final VoidCallback? onSubmit;
  final bool? obscureText;
  final BoxBorder? border;
  final TextInputFormatter? textInputFormatter;

  const CustomTextForm({
    required this.formKey,
    required this.hintText,
    required this.validator,
    required this.controller,
    required this.textInputType,
    this.obscureText,
    this.onSubmit,
    this.border,
    this.textInputFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: border ?? Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: TextFormField(
            inputFormatters:
                textInputFormatter != null ? [textInputFormatter!] : null,
            obscureText: obscureText ?? false,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: InputBorder.none,
            ),
            keyboardType: textInputType,
            validator: validator,
            onFieldSubmitted: (value) {
              if (onSubmit != null) {
                onSubmit!();
              }
            },
          ),
        ),
      ),
    );
  }
}
