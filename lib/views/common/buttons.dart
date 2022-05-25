import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import 'package:spenza/utilities/constants/colors.dart';
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

/// Green Button with loading icon
///
/// @param text Text inside the button
/// @param doOnPressed Function when user clicks
class CustomPrimaryButtonWIthLoading extends StatelessWidget {
  final String text;
  final VoidCallback doOnPressed;
  final bool loading;
  const CustomPrimaryButtonWIthLoading(
      {Key? key,
      required this.text,
      required this.doOnPressed,
      required this.loading})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: doOnPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor:
            loading ? Color.fromARGB(255, 55, 85, 34) : CColors.PrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 19.0),
        child: Center(
          child: loading
              ? SizedBox.square(
                  dimension: 18.0, child: CircularProgressIndicator())
              : CustomTextBold(text: text, size: 15, color: Colors.white),
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
  final VoidCallback doOnPressed;
  const CustomRadioButton({
    Key? key,
    required this.text,
    required this.color,
    required this.fontColor,
    required this.doOnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => doOnPressed,
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

/// Back Button
class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: const BackButtonIcon(),
      color: CColors.MainText,
      onPressed: () => Navigator.maybePop(context),
    );
  }
}

/// Close Button
class CustomCloseButton extends StatelessWidget {
  const CustomCloseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: const Icon(Icons.close),
      color: CColors.MainText,
      onPressed: () => Navigator.maybePop(context),
    );
  }
}

/// SELECTED: Radio Button text: Input character style
TextStyle customRadioButtonTextStyleSelected() {
  return TextStyle(
      fontFamily: "Inter",
      fontWeight: FontWeight.w700,
      fontSize: 15,
      letterSpacing: 0.5,
      color: CColors.White);
}

/// UNSELECTED: Radio Button text: Input character style
TextStyle customRadioButtonTextStyleUnselected() {
  return TextStyle(
      fontFamily: "Inter",
      fontWeight: FontWeight.w700,
      fontSize: 15,
      letterSpacing: 0.5,
      color: CColors.SecondaryText);
}

GroupButtonOptions customGroupButtonOptions() {
  return GroupButtonOptions(
    selectedTextStyle: customRadioButtonTextStyleSelected(),
    unselectedTextStyle: customRadioButtonTextStyleUnselected(),
    selectedColor: CColors.PrimaryColor,
    unselectedColor: CColors.Form,
    borderRadius: BorderRadius.circular(32.0),
    spacing: 10,
    runSpacing: 20,
    elevation: 0.0,
    selectedShadow: [],
    unselectedShadow: [],
    textPadding: const EdgeInsets.symmetric(
      vertical: 19.0,
      horizontal: 12.0,
    ),
    mainGroupAlignment: MainGroupAlignment.start,
    alignment: Alignment.centerLeft,
  );
}
