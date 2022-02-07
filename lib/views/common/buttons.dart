import 'package:flutter/material.dart';

import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/utilities/constants/fonts.dart';
import 'package:spenza/views/common/texts.dart';

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
    return OutlinedButton(
      onPressed: doOnPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: CColors.PrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 19.0),
        child: Center(
          child: CustomTextBold(text: text, size: 15, color: Colors.white),
        ),
      ),
    );
  }
}
