import 'package:flutter/material.dart';
import 'package:flutter_gallery_ui/theme/theme.dart';
import 'package:flutter_svg/svg.dart';

class AuthField extends StatelessWidget {

  final TextEditingController controller;
  final String hintText;
  final double fontSize;
  final String frontIcon;
  final bool inputObcureText;

  const AuthField({super.key,
    required this.controller,
    required this.hintText,
    required this.fontSize,
    required this.frontIcon,
    this.inputObcureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: inputObcureText,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: PaletteLightMode.blueColor),
        ),
        contentPadding: const EdgeInsets.all(22),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: fontSize),
        prefixIcon: Transform.scale(
          scale: 0.6,
          child: SvgPicture.asset(frontIcon),
        )
      ),
    );
  }
}