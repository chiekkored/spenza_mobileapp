import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/inputs.dart';

import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/home/home.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextBold(
                text: "Reset your password",
                size: 22,
                color: CColors.PrimaryText,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomTextMedium(
                  text: "Please enter your new password",
                  size: 15,
                  color: CColors.SecondaryText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: CustomAuthInput(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    icon: Icons.lock_outline,
                    hintText: "Password"),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: CustomTextMedium(
                      text: "Your Password must contain:",
                      size: 17,
                      color: CColors.PrimaryText),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CustomTextBold(
                      text: "Atleast 6 characters",
                      size: 15,
                      color: CColors.MainText),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CustomTextMedium(
                      text: "Contains a number",
                      size: 15,
                      color: CColors.SecondaryText),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 23.0),
                child: CustomPrimaryButton(
                    text: "Done",
                    doOnPressed: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => HomeScreen()),
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
