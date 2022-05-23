import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/inputs.dart';
import 'package:spenza/views/common/popovers.dart';

import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/auth/forgot_password/password_verification/passwordVerification.dart';
import 'package:spenza/views/screens/auth/sign_in/sigin.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  TextEditingController passwordTextController = TextEditingController();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;
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
              text: "Enter yor email to recover your password",
              size: 15,
              color: CColors.SecondaryText,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: CustomAuthInput(
                controller: passwordTextController,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email_outlined,
                textInputAction: TextInputAction.done,
                hintText: "Email or phone number"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: CustomPrimaryButtonWIthLoading(
                loading: _isLoading,
                text: "Send",
                doOnPressed: () async {
                  if (!_isLoading) {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      await _firebaseAuth
                          .sendPasswordResetEmail(
                              email: passwordTextController.text)
                          .then((value) {
                        showCustomDialog(
                            context,
                            "Password Recovery",
                            "A link has been sent to your email",
                            "Okay",
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()),
                              (Route<dynamic> route) => false,
                            ));
                      });
                    } on FirebaseAuthException catch (e) {
                      showCustomDialog(
                          context, "Error", e.message.toString(), "Okay", null);
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  } else {
                    return null;
                  }
                  // return Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PasswordVerificationScreen()),
                  //   );
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: CustomTransparentButton(
                text: "Back to sign in",
                doOnPressed: () {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return SignInScreen();
                      },
                    ),
                    (_) => false,
                  );
                  // return Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => PasswordVerificationScreen()),
                  //   );
                }),
          ),
        ],
      ),
    )));
  }
}
