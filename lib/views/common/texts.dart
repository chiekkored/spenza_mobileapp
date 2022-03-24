import 'package:flutter/material.dart';

/// Font weight: 700
///
/// @param text Text value
/// @param size Text font size
/// @param color Text font color
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
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w700,
          fontSize: size,
          letterSpacing: 0.5,
          color: color),
    );
  }
}

/// Font weight: 500
///
/// @param text Text value
/// @param size Text font size
/// @param color Text font color
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
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w500,
          fontSize: size,
          letterSpacing: 0.5,
          color: color),
    );
  }
}

/// Font weight: 600
///
/// @param text Text value
/// @param size Text font size
/// @param color Text font color
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
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w600,
          fontSize: size,
          letterSpacing: 0.5,
          color: color),
    );
  }
}

/// Font weight: 400
///
/// @param text Text value
/// @param size Text font size
/// @param color Text font color
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
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w400,
          fontSize: size,
          letterSpacing: 0.5,
          color: color),
    );
  }
}
