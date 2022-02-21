import 'package:flutter/material.dart';

class CustomTextBold extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  const CustomTextBold(
      {Key? key, required this.text, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w700,
          fontSize: size,
          letterSpacing: 0.5,
          color: color),
    );
  }
}

class CustomTextMedium extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  const CustomTextMedium(
      {Key? key, required this.text, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w500,
          fontSize: size,
          letterSpacing: 0.5,
          color: color),
    );
  }
}

class CustomTextSemiBold extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  const CustomTextSemiBold(
      {Key? key, required this.text, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w600,
          fontSize: size,
          letterSpacing: 0.5,
          color: color),
    );
  }
}

class CustomTextRegular extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  const CustomTextRegular(
      {Key? key, required this.text, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w400,
          fontSize: size,
          letterSpacing: 0.5,
          color: color),
    );
  }
}
