import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:spenza/views/screens/auth/forgot_password/password_recovery/passwordRecovery.dart';
import 'package:spenza/views/screens/auth/sign_up/signup.dart';
import 'package:spenza/views/screens/home/home.dart';

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
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomTextMedium(
                  text: "Please enter your account here",
                  size: 15,
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 26.0, right: 12.0),
                      child: Icon(
                        Icons.email_outlined,
                        color: Colors.black,
                      ),
                    ),
                    hintText: "Email or phone number",
                    hintStyle: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        letterSpacing: 0.5,
                        color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 26.0, right: 12.0),
                      child: Icon(
                        Icons.lock_outline,
                        color: Colors.black,
                      ),
                    ),
                    hintText: "Password",
                    hintStyle: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        letterSpacing: 0.5,
                        color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => PasswordRecoveryScreen()),
                      ),
                      child: CustomTextMedium(
                        text: "Forgot password?",
                        size: 15,
                        color: Colors.black,
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 72.0),
                child: OutlinedButton(
                    onPressed: () => Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => HomeScreen())),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 19.0),
                      child: Center(
                        child: CustomTextBold(
                            text: "Login", size: 15, color: Colors.white),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: CustomTextMedium(
                    text: "Or continue with", size: 15, color: Colors.grey),
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
                      CupertinoPageRoute(builder: (context) => SignUpScreen())),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                            letterSpacing: 0.5,
                            color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(text: "Don't have any account? "),
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.green[700],
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

class CustomTextBold extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  const CustomTextBold(
      {Key? key, required this.text, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w700,
          fontSize: size,
          letterSpacing: 0.5,
          color: color),
    );
  }
}

class CustomTextMedium extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  const CustomTextMedium(
      {Key? key, required this.text, required this.size, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: "Inter",
          fontWeight: FontWeight.w500,
          fontSize: size,
          letterSpacing: 0.5,
          color: color),
    );
  }
}
