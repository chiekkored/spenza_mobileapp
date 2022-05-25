import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> setNewUser(User userCredential) async {
    AuthViewModel _authVM = AuthViewModel();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.uid)
        .set({
      "uid": userCredential.uid,
      "name": userCredential.email!
          .substring(0, userCredential.email!.indexOf('@')),
      "email": userCredential.email ?? "",
      "dpUrl": userCredential.photoURL ??
          "https://firebasestorage.googleapis.com/v0/b/spenza-recipe-app.appspot.com/o/placeholders%2Ficon.png?alt=media&token=18603a2b-2386-48e3-ae79-d11d8adaef52",
    }).then((value) async {
      _users.uid = userCredential.uid;
      _users.name = userCredential.email!
          .substring(0, userCredential.email!.indexOf('@'));
      _users.email = userCredential.email ?? "";
      _users.dpUrl = userCredential.photoURL ??
          "https://firebasestorage.googleapis.com/v0/b/spenza-recipe-app.appspot.com/o/placeholders%2Ficon.png?alt=media&token=18603a2b-2386-48e3-ae79-d11d8adaef52";
      return userCredential;
    }).then((document) => _authVM.setNewPreferences(document));
  }

  Future<bool> getUserPreference() async {
    return await SharedPreferences.getInstance().then((pref) {
      if (pref.getString('user') != null) {
        final data = jsonDecode(pref.getString('user')!);
        _users.uid = data["uid"];
        _users.email = data["email"];
        _users.name = data["name"];
        _users.dpUrl = data["dpUrl"];
        return true;
      } else {
        return false;
      }
    });
  }
}
