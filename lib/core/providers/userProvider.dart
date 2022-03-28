import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spenza/core/models/userModel.dart';
import 'package:spenza/core/viewmodels/authViewModels.dart';

class UserProvider extends ChangeNotifier {
  UserModel _users = UserModel(uid: "", email: "", name: "", dpUrl: "");
  UserModel get userInfo => _users;

  Future<void> setUser(String uid) async {
    AuthViewModel _authVM = AuthViewModel();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        _users.uid = documentSnapshot["uid"];
        _users.name = documentSnapshot["name"];
        _users.email = documentSnapshot["email"];
        _users.dpUrl = documentSnapshot["dpUrl"];
        return documentSnapshot;
      }
    }).then((document) => _authVM.setPreferences(document!));
  }

  void getUserPreference() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.getString('user') != null) {
      final data = jsonDecode(pref.getString('user')!);
      _users.uid = data["uid"];
      _users.email = data["email"];
      _users.name = data["name"];
      _users.dpUrl = data["dpUrl"];
    } else {
      // pref.clear();
      // await FirebaseAuth.instance.signOut();
      // print("logout from user preference");
    }
  }
}
