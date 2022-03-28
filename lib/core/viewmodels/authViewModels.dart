import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spenza/views/common/popovers.dart';

class AuthViewModel {
  Future<void> setPreferences(DocumentSnapshot document) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(
        'user',
        jsonEncode({
          "uid": document["uid"],
          "email": document["email"],
          "name": document["name"],
          "dpUrl": document["dpUrl"]
        }));
  }

  Future signInEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      if (email == "" && password == "") {
        return null;
      }
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // });
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        showCustomDialog(context, "User Not Found",
            "No user found for that email", "Okay", null);
        print('No user found for that email.');
      } else if (e.code == 'invalid-email') {
        showCustomDialog(context, "Invalid Email",
            "Wrong email provided for that user", "Okay", null);
        print('Wrong password provided for that user.');
      } else if (e.code == 'wrong-password') {
        showCustomDialog(context, "Invalid Password",
            "Wrong password provided for that user", "Okay", null);
        print('Wrong password provided for that user.');
      } else {}
      return null;
    }
  }

  Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    await FirebaseAuth.instance.signOut();
    print("logout");
  }
}
