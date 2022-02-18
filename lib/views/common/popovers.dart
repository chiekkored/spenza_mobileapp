import 'package:flutter/material.dart';
import 'package:spenza/utilities/constants/colors.dart';

void showCustomBottomSheet(context) {
  showBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 50.0,
          color: CColors.White,
          child: Center(child: Text("data")),
        );
      });
}
