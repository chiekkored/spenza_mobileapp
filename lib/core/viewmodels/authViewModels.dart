import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    debugPrint("✅ [setPreferences] Success");
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
    debugPrint("✅ [setNewPreferences] Success");
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
      debugPrint(e.code);
      if (e.code == 'user-not-found') {
        showCustomDialog(context, "User Not Found",
            "No user found for that email", "Okay", null);
        debugPrint('No user found for that email.');
      } else if (e.code == 'invalid-email') {
        showCustomDialog(context, "Invalid Email",
            "Wrong email provided for that user", "Okay", null);
        debugPrint('Wrong password provided for that user.');
      } else if (e.code == 'wrong-password') {
        showCustomDialog(context, "Invalid Password",
            "Wrong password provided for that user", "Okay", null);
        debugPrint('Wrong password provided for that user.');
      } else if (e.code == 'network-request-failed') {
        showCustomDialog(context, "Connection Error",
            "Please check connection and try again", "Okay", null);
        debugPrint('No Connection.');
      } else {}
      return null;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      await GoogleSignIn().disconnect();
    } catch (e) {
      debugPrint(e.toString());
    }
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future signUp(BuildContext context, String email, String password) async {
    try {
      return await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
        if (!userCredential.user!.emailVerified) {
          await userCredential.user!.sendEmailVerification();
        }

        debugPrint("✅ [signUp] Success");
        return userCredential;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showCustomDialog(context, "Weak Password",
            "The password provided is too weak.", "Okay", null);
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showCustomDialog(context, "Invalid Email",
            "The account already exists for that email.", "Okay", null);
        debugPrint('The account already exists for that email.');
      }
    }
  }

  Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    await FirebaseAuth.instance.signOut();
    debugPrint("✅ [logout] Success");
  }
}
