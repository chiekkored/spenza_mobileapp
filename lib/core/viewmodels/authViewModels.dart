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

  Future<void> setNewPreferences(User user) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(
        'user',
        jsonEncode({
          "uid": user.uid,
          "email": user.email ?? "",
          "name": user.displayName ?? "",
          "dpUrl": user.photoURL ?? ""
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
      } else if (e.code == 'network-request-failed') {
        showCustomDialog(context, "Connection Error",
            "Please check connection and try again", "Okay", null);
        print('No Connection.');
      } else {}
      return null;
    }
  }

  Future signUp(BuildContext context, String email, String password) async {
    try {
      return await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
        if (!userCredential.user!.emailVerified) {
          await userCredential.user!.sendEmailVerification();
        }
        return userCredential;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showCustomDialog(context, "Weak Password",
            "The password provided is too weak.", "Okay", null);
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showCustomDialog(context, "Invalid Email",
            "The account already exists for that email.", "Okay", null);
        print('The account already exists for that email.');
      }
    }
  }

  Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    await FirebaseAuth.instance.signOut();
    print("logout");
  }
}
