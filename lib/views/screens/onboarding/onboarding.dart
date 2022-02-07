import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/utilities/constants/fonts.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/screens/auth/sign_in/sigin.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 160.0,
              height: 160.0,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                'Cook with what you have',
                style: TextStyle(
                    fontFamily: CFonts.Inter,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: CColors.MainText,
                    letterSpacing: 0.5),
              ),
            ),
            SizedBox(
              width: 210.0,
              child: Text(
                'Let’s join our community to reduce waste and cook better food!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: CFonts.Inter,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500,
                  color: CColors.SecondaryText,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        margin: const EdgeInsets.only(bottom: 70.0),
        height: 56.0,
        child: CustomPrimaryButton(
          text: "Get Started",
          doOnPressed: () => Navigator.push(
              context, CupertinoPageRoute(builder: (_) => SignInScreen())),
        ),
      ),
    );
  }
}
