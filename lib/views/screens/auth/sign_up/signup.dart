import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/authViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/inputs.dart';

import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/auth/verification/verification.dart';
import 'package:spenza/views/screens/auth/verification/verificationEmail.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool charValue = false;
  bool numValue = false;
  bool _isLoading = false;
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  AuthViewModel _authVM = AuthViewModel();

  void _checkPassword(String password) {
    if (password.length > 6) {
      setState(() {
        charValue = true;
      });
    } else {
      setState(() {
        charValue = false;
      });
    }
    if (password.contains(RegExp(r'[0-9]'))) {
      setState(() {
        numValue = true;
      });
    } else {
      setState(() {
        numValue = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.read<UserProvider>();
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
                  child: TextField(
                    onChanged: (pass) => _checkPassword(pass),
                    controller: passwordTextController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: const BorderSide(
                          color: CColors.Outline,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: CColors.PrimaryColor)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 26.0, right: 12.0),
                        child: Icon(
                          Icons.lock_outline,
                          color: CColors.PrimaryText,
                        ),
                      ),
                      hintText: "Password",
                      hintStyle: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          letterSpacing: 0.5,
                          color: CColors.SecondaryText),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  )),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          splashRadius: 0.0,
                          checkColor: CColors.PrimaryColor,
                          fillColor: charValue
                              ? MaterialStateProperty.all(CColors.AccentColor)
                              : MaterialStateProperty.all(CColors.PrimaryColor),
                          value: charValue,
                          shape: CircleBorder(),
                          onChanged: (bool? value) {
                            return null;
                          },
                        ),
                      ),
                      CustomTextMedium(
                          text: "Atleast 6 characters",
                          size: 15,
                          color: charValue
                              ? CColors.MainText
                              : CColors.SecondaryText),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          splashRadius: 0.0,
                          checkColor: CColors.PrimaryColor,
                          fillColor: numValue
                              ? MaterialStateProperty.all(CColors.AccentColor)
                              : MaterialStateProperty.all(CColors.PrimaryColor),
                          value: numValue,
                          shape: CircleBorder(),
                          onChanged: (bool? value) {
                            return null;
                          },
                        ),
                      ),
                      CustomTextMedium(
                        text: "Contains a number",
                        size: 15,
                        color:
                            numValue ? CColors.MainText : CColors.SecondaryText,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 23.0),
                child: CustomPrimaryButtonWIthLoading(
                  text: "Sign Up",
                  loading: _isLoading,
                  doOnPressed: () async {
                    if (emailTextController.text == "" &&
                        passwordTextController.text == "") {
                      return null;
                    }
                    if (!charValue || !numValue) {
                      return null;
                    }
                    if (!_isLoading) {
                      setState(() {
                        _isLoading = true;
                      });
                      await _authVM
                          .signUp(context, emailTextController.text,
                              passwordTextController.text)
                          .then((doc) async {
                        if (doc != null) {
                          await userProvider.setNewUser(doc.user);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    VerificationEmailScreen()),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      });
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
