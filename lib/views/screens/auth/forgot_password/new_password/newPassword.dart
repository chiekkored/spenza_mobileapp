import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:spenza/views/screens/auth/verification/verification.dart';
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
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomTextMedium(
                  text: "Please enter your new password",
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
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: CustomTextMedium(
                      text: "Your Password must contain:",
                      size: 17,
                      color: Colors.black),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CustomTextMedium(
                      text: "Atleast 6 characters",
                      size: 15,
                      color: Colors.black),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CustomTextMedium(
                      text: "Contains a number", size: 15, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 23.0),
                child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
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
                            text: "Done", size: 15, color: Colors.white),
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
