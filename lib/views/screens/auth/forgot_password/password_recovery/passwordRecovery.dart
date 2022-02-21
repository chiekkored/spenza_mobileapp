import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/inputs.dart';

import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/auth/forgot_password/password_verification/passwordVerification.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
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
            text: "Password recovery",
            size: 22,
            color: CColors.PrimaryText,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: CustomTextMedium(
              text: "Enter yor email to recover ourr password",
              size: 15,
              color: CColors.SecondaryText,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: CustomAuthInput(
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email_outlined,
                hintText: "Email or phone number"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: CustomPrimaryButton(
                text: "Sign In",
                doOnPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordVerificationScreen()),
                    )),
          ),
        ],
      ),
    )));
  }
}
