import 'package:flutter/material.dart';

import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/utilities/constants/fonts.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback doOnPressed;
  const CustomPrimaryButton({
    Key? key,
    required this.text,
    required this.doOnPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: CFonts.Inter,
          fontSize: 15.0,
          fontWeight: FontWeight.w700,
          color: CColors.White,
          letterSpacing: 0.7,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: CColors.PrimaryColor,
        padding: EdgeInsets.symmetric(vertical: 19),
        shape: StadiumBorder(),
      ),
      onPressed: doOnPressed,
    );
  }
}
