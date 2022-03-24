import 'package:flutter/material.dart';

import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/utilities/constants/fonts.dart';
import 'package:spenza/views/common/texts.dart';

/// Green Button
///
/// @param text Text inside the button
/// @param doOnPressed Function when user clicks
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

/// Gray Button
///
/// @param text Text inside the button
/// @param doOnPressed Function when user clicks
class CustomSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback doOnPressed;
  const CustomSecondaryButton({
    Key? key,
    required this.text,
    required this.doOnPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: doOnPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: CColors.Form,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 19.0),
        child: Center(
          child: CustomTextBold(text: text, size: 15, color: CColors.MainText),
        ),
      ),
    );
  }
}

/// Radio Button
///
/// @param text Text inside the button
/// @param color Button background color
/// @param fontColor Text font color
class CustomRadioButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color fontColor;
  const CustomRadioButton({
    Key? key,
    required this.text,
    required this.color,
    required this.fontColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide.none,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 19.0, horizontal: 12.0),
        child: Center(
          child: CustomTextBold(text: text, size: 15, color: fontColor),
        ),
      ),
    );
  }
}

/// Outlined Button
///
/// @param text Text inside the button
/// @param doOnPressed Function when user clicks
class CustomTransparentButton extends StatelessWidget {
  final String text;
  final VoidCallback doOnPressed;
  const CustomTransparentButton({
    Key? key,
    required this.text,
    required this.doOnPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: doOnPressed,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 19.0),
        child: Center(
          child: CustomTextBold(text: text, size: 15, color: CColors.MainText),
        ),
      ),
    );
  }
}
