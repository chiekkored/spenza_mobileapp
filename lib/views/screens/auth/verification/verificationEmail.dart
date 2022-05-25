import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/viewmodels/authViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/auth/sign_in/sigin.dart';

class VerificationEmailScreen extends StatefulWidget {
  const VerificationEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerificationEmailScreen> createState() =>
      _VerificationEmailScreenState();
}

class _VerificationEmailScreenState extends State<VerificationEmailScreen> {
  AuthViewModel _authVM = AuthViewModel();
  bool _resendState = true;
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
                text: "Account Verification",
                size: 22,
                color: CColors.PrimaryText,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomTextMedium(
                  text: "We've sent a verification link to your email",
                  size: 15,
                  color: CColors.SecondaryText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: CustomPrimaryButton(
                    text: "Go back to signin",
                    doOnPressed: () {
                      _authVM.logout();
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return SignInScreen();
                          },
                        ),
                        (_) => false,
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CustomTransparentButton(
                    text: "Send again",
                    doOnPressed: () async {
                      if (_resendState) {
                        User? user = FirebaseAuth.instance.currentUser;
                        await user!.sendEmailVerification();
                        setState(() {
                          _resendState = false;
                        });
                      } else {
                        return null;
                      }
                    }),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 16.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       CustomTextMedium(
              //           text: "Send again in: ",
              //           size: 15,
              //           color: CColors.PrimaryText),
              //       CustomTextMedium(
              //           text: "03:12", size: 15, color: Colors.red),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
