import 'package:flutter/Material.dart';
import 'package:provider/provider.dart';
import 'package:spenza/core/providers/userProvider.dart';
import 'package:spenza/core/viewmodels/authViewModels.dart';
import 'package:spenza/utilities/constants/colors.dart';
import 'package:spenza/views/common/buttons.dart';
import 'package:spenza/views/common/inputs.dart';

import 'package:spenza/views/common/texts.dart';
import 'package:spenza/views/screens/auth/forgot_password/password_recovery/passwordRecovery.dart';
import 'package:spenza/views/screens/auth/sign_up/signup.dart';
import 'package:spenza/views/screens/auth/verification/verificationEmail.dart';
import 'package:spenza/views/screens/home/navigation.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  AuthViewModel _authVM = AuthViewModel();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  dynamic loginAttempt() async {
    if (emailTextController.text == "" &&
        passwordTextController.text == "" &&
        _isGoogleLoading) {
      return null;
    }
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      dynamic doc = await _authVM.signInEmailAndPassword(
          context, emailTextController.text, passwordTextController.text);
      if (doc != null) {
        var userProvider = context.read<UserProvider>();
        await userProvider.setUser(doc.user!.uid);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => doc.user!.emailVerified
                  ? Navigation()
                  : VerificationEmailScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = context.read<UserProvider>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: CColors.White,
        child: Center(
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
                      controller: emailTextController,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email_outlined,
                      textInputAction: TextInputAction.next,
                      hintText: "Email"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CustomAuthInput(
                      controller: passwordTextController,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      icon: Icons.lock_outline,
                      textInputAction: TextInputAction.done,
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
                    child: CustomPrimaryButtonWIthLoading(
                      text: "Login",
                      loading: _isLoading,
                      doOnPressed: loginAttempt,
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
                    onPressed: () async {
                      if (!_isGoogleLoading) {
                        dynamic doc = await _authVM.signInWithGoogle();
                        setState(() {
                          _isGoogleLoading = true;
                        });
                        if (doc != null) {
                          // doc as UserCredential;
                          if (doc.additionalUserInfo!.isNewUser) {
                            await userProvider.setNewUser(doc.user);
                          } else {
                            await userProvider.setUser(doc.user!.uid);
                          }
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => doc.user!.emailVerified
                                    ? Navigation()
                                    : VerificationEmailScreen()),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          setState(() {
                            _isGoogleLoading = false;
                          });
                        }
                      } else {
                        return null;
                      }
                    },
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
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen())),
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
      ),
    );
  }
}
