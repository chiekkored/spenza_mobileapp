import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadViewModel {
  Future<bool> uploadRecipe(
      String uid,
      String coverPath,
      String foodName,
      String description,
      double cookingDuration,
      List<TextEditingController> ingredientList,
      List<TextEditingController> stepsList,
      List<XFile?> imagesList) async {
    int stepsCount = 0;
    List<String> _ingredientText = [];
    List<String> _imagesPath = [];
    List<Map<String, dynamic>> _steps = [];
    String coverUrl;

    // Extract Texts from TextEditingController List
    for (var item in ingredientList) {
      _ingredientText.add(item.text);
    }
    // Extract Paths from XFile List
    for (var item in imagesList) {
      _imagesPath.add(item!.path);
    }

    // Upload images to Firebase Storage
    final storageRef = FirebaseStorage.instance.ref();
    try {
      for (var item in stepsList) {
        DateTime now = DateTime.now();
        Reference storageRefDest = storageRef.child("posts/$uid/$now");
        await storageRefDest.putFile(File(_imagesPath[stepsCount]));
        String imageUrl = await storageRefDest.getDownloadURL();
        _steps.add({"stepsText": item.text, "stepsImage": imageUrl});

        stepsCount++;
      }

      DateTime now = DateTime.now();
      Reference storageRefDest = storageRef.child("posts/$uid/$now");
      await storageRefDest.putFile(File(coverPath));
      coverUrl = await storageRefDest.getDownloadURL();
    } on FirebaseException catch (e) {
      print(e.message);
      return false;
    }

    CollectionReference _usersPosts = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("posts");
    bool result = await _usersPosts
        .add({
          "postRecipeTitle": foodName,
          "postDuration": "${cookingDuration.round().toString()} mins",
          "postDescription": description,
          "authorUid": uid,
          "postImageUrl": coverUrl,
          "postPercent": "80%",
          "ingredients": _ingredientText,
          "steps": _steps
        })
        .then((value) => true)
        .catchError((e) {
          print(e.toString());
          return false;
        });
    return result;
  }
}



                          //     .collection('users')
                          //     .doc(FirebaseAuth.instance.currentUser!.uid)
                          //     .collection("posts")
                          //     .add({
                          //   "postDuration": "40 mins",
                          //   "postImageUrl":
                          //       "https://picsum.photos/id/30/1280/901",
                          //   "postPercent": "68%",
                          //   "postRecipeTitle": "Pancake",
                          //   "authorUid": FirebaseAuth.instance.currentUser!.uid
                          // }).then((value) => print("added posts"));