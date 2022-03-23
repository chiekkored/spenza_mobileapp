import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/inputs.dart';

import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/auth/verification/verification.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController emailTextController;
  late TextEditingController passwordTextController;
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
                text: "Welcome!",
                size: 22,
                color: CColors.PrimaryText,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomTextMedium(
                  text: "Please enter your account here",
                  size: 15,
                  color: CColors.SecondaryText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: CustomAuthInput(
                    controller: emailTextController,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.email_outlined,
                    hintText: "Email or phone number"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CustomAuthInput(
                    controller: passwordTextController,
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
                  child: CustomTextMedium(
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
                    color: CColors.SecondaryText,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 23.0),
                child: CustomPrimaryButton(
                    text: "Sign Up",
                    doOnPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerificationCodeScreen()),
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
