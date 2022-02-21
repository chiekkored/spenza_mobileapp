import 'package:flutter/Material.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/inputs.dart';

import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/auth/forgot_password/password_recovery/passwordRecovery.dart';
import 'package:spenza/views/screens/auth/sign_up/signup.dart';
import 'package:spenza/views/screens/home/navigation.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextBold(
                text: "Welcome Back!",
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
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.email_outlined,
                    hintText: "Email or phone number"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: CustomAuthInput(
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    icon: Icons.lock_outline,
                    hintText: "Password"),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PasswordRecoveryScreen()),
                      ),
                      child: CustomTextMedium(
                        text: "Forgot password?",
                        size: 15,
                        color: CColors.MainText,
                      ),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 72.0),
                  child: CustomPrimaryButton(
                    text: "Login",
                    doOnPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Navigation())),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: CustomTextMedium(
                    text: "Or continue with",
                    size: 15,
                    color: CColors.SecondaryText),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 19.0),
                    child: Center(
                      child: CustomTextBold(
                        text: "Google",
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpScreen())),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                            letterSpacing: 0.5,
                            color: CColors.PrimaryText),
                        children: <TextSpan>[
                          TextSpan(text: "Don't have any account? "),
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: CColors.PrimaryColor,
                            ),
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
