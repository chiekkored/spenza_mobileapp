import 'package:flutter/material.dart';
import 'package:spenza/core/viewmodels/authViewModels.dart';
import 'package:spenza/views/screens/auth/sign_in/sigin.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  AuthViewModel _authVM = AuthViewModel();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: TextButton(
              onPressed: () {
                _authVM.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text("data")),
        ),
      ),
    );
  }
}
