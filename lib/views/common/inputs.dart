import 'package:flutter/material.dart';
import 'package:spenza/utilities/constants/colors.dart';

/// For inputs with icons
/// Commonly used on authentication pages
class CustomAuthInput extends StatelessWidget {
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  const CustomAuthInput({
    Key? key,
    required this.obscureText,
    required this.keyboardType,
    required this.icon,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(
            color: CColors.Outline,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: CColors.PrimaryColor)),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 26.0, right: 12.0),
          child: Icon(
            icon,
            color: CColors.PrimaryText,
          ),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.w500,
            fontSize: 15,
            letterSpacing: 0.5,
            color: CColors.SecondaryText),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );
  }
}

/// Outlined text fields: Input character style
TextStyle customTextFieldTextStyle() {
  return TextStyle(
      fontFamily: "Inter",
      fontWeight: FontWeight.w500,
      fontSize: 15,
      letterSpacing: 0.5,
      color: CColors.MainText);
}

/// Outlined text fields: Text field decoration
///
/// @param hint Text hint
InputDecoration customTextFieldInputDecoration({required String hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
        fontFamily: "Inter",
        fontWeight: FontWeight.w500,
        fontSize: 15,
        letterSpacing: 0.5,
        color: CColors.SecondaryText),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32.0),
      borderSide: const BorderSide(
        color: CColors.Outline,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32.0),
      borderSide: const BorderSide(
        color: CColors.PrimaryColor,
        width: 2.0,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(32.0),
    ),
  );
}

/// Outlined text fields: Text field decoration square
///
/// @param hint Text hint
InputDecoration customTextFieldInputDecorationSquare({required String hint}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
        fontFamily: "Inter",
        fontWeight: FontWeight.w500,
        fontSize: 15,
        letterSpacing: 0.5,
        color: CColors.SecondaryText),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: CColors.Outline,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: CColors.PrimaryColor,
        width: 2.0,
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}
