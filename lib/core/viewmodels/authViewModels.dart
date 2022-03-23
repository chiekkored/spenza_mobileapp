import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spenza/core/models/userModel.dart';
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
        }));
  }

  Future<void> getPreferences() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.getString('user') != null) {
      final data = jsonDecode(pref.getString('user')!);
      UserModel user = UserModel(
        uid: data["uid"],
        email: data["email"],
        name: data["name"],
      );
      return data;
    }
  }

  Future signInEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      print("---");
      print("hello");
      print("---");
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      //     .then((userCredential) async {
      //   print("---");
      //   print("hi");
      //   print("---");
      //   String _userID = userCredential.user!.uid;
      //   print(_userID);
      //   return await FirebaseFirestore.instance
      //       .collection('users')
      //       .doc(_userID)
      //       .get()
      //       .then(
      //     (DocumentSnapshot documentSnapshot) async {
      //       if (documentSnapshot.exists) {
      //         await setPreferences(documentSnapshot);
      //       }

      //         return documentSnapshot;
      //     },
      //   );
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
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    print("logout");
  }
}
