import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pinput/pin_put/pin_put.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/auth/forgot_password/new_password/newPassword.dart';

class PasswordVerificationScreen extends StatefulWidget {
  const PasswordVerificationScreen({Key? key}) : super(key: key);

  @override
  _PasswordVerificationScreenState createState() =>
      _PasswordVerificationScreenState();
}

class _PasswordVerificationScreenState
    extends State<PasswordVerificationScreen> {
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
                text: "Check your email",
                size: 22,
                color: CColors.PrimaryText,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomTextMedium(
                  text: "We've sent the code to your email",
                  size: 15,
                  color: CColors.SecondaryText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 48.0),
                child: Container(
                  height: 72.0,
                  child: PinPut(
                    fieldsCount: 4,
                    eachFieldWidth: 72.0,
                    textStyle: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                        fontSize: 34.0,
                        letterSpacing: 0.5),
                    followingFieldDecoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    selectedFieldDecoration: BoxDecoration(
                      border: Border.all(color: CColors.PrimaryColor),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    submittedFieldDecoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextMedium(
                      text: "code expires in: ",
                      size: 15,
                      color: CColors.PrimaryText),
                  CustomTextMedium(text: "03:12", size: 15, color: Colors.red),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: CustomPrimaryButton(
                    text: "Next",
                    doOnPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewPasswordScreen()),
                        )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: OutlinedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     CupertinoPageRoute(
                      //         builder: (context) => VerificationCodeScreen()),
                      //   );
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 19.0),
                      child: Center(
                        child: CustomTextBold(
                            text: "Send again",
                            size: 15,
                            color: CColors.SecondaryText),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
