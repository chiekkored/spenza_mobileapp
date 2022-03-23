import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/models/userModel.dart';

class UserProvider extends ChangeNotifier {
  UserModel _users = UserModel(uid: "", email: "", name: "");
  UserModel get userInfo => _users;
  Future<void> setUser(String uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        _users.email = documentSnapshot["email"];
      }
    });
  }
}
