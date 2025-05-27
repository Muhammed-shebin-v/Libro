import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:libro/core/themes/fonts.dart';


class CustomForm extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
   final bool obsecure;
   const CustomForm({
    super.key,
    required this.title,
    required this.controller,
    required this.validator,
    this.obsecure = false,
    this.suffixIcon
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          obscureText: obsecure,
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0),width: 1),
              borderRadius: BorderRadius.circular(25.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.color10,
              ),
              borderRadius: BorderRadius.circular(25.0),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(25.0),
            ),
            fillColor: AppColors.color30,
            filled: true,
            alignLabelWithHint: true,
            hintStyle: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 14,
            ),
            labelText: title,
            border: OutlineInputBorder(),
          ),
        ),
        Gap(10),
      ],
    );
  }
}
