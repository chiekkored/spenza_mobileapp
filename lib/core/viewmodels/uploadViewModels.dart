import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

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

  Future<bool> uploadPantry(String uid, String coverPath, String foodName,
      String quantity, String unit) async {
    final storageRef = FirebaseStorage.instance.ref();
    try {
      DateTime now = DateTime.now();
      Reference storageRefDest = storageRef.child("posts/$uid/$now");
      await storageRefDest.putFile(File(coverPath));
      String imageUrl = await storageRefDest.getDownloadURL();

      CollectionReference _usersPantry = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("pantries");
      bool result = await _usersPantry
          .add({
            "pantryFoodTitle": foodName,
            "pantryQuantity": quantity,
            "pantryUnit": unit,
            "pantryImageUrl": imageUrl,
          })
          .then((value) => true)
          .catchError((e) {
            print(e.toString());
            return false;
          });
      return result;
    } on FirebaseException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<List<ImageLabel>> getSuggested(InputImage inputImage) async {
    List<ImageLabel> suggestedList = [];
    FirebaseCustomModel objectLabelerModel =
        await FirebaseModelDownloader.instance.getModel('Object-Labeler',
            FirebaseModelDownloadType.localModelUpdateInBackground);
    FirebaseCustomModel foodModel = await FirebaseModelDownloader.instance
        .getModel(
            'Food', FirebaseModelDownloadType.localModelUpdateInBackground);

    final imagePDModel = GoogleMlKit.vision.imageLabeler();
    final imageLabelerOLModel = GoogleMlKit.vision.imageLabeler(
        CustomImageLabelerOptions(
            customModel: CustomLocalModel.file,
            customModelPath: objectLabelerModel.file.path));
    final imageLabelerFModel = GoogleMlKit.vision.imageLabeler(
        CustomImageLabelerOptions(
            customModel: CustomLocalModel.file,
            customModelPath: foodModel.file.path));

    final List<ImageLabel> mlKitLabels =
        await imagePDModel.processImage(inputImage);
    final List<ImageLabel> objectLabels =
        await imageLabelerOLModel.processImage(inputImage);
    final List<ImageLabel> foodLabels =
        await imageLabelerFModel.processImage(inputImage);
    // suggestedList.add([mlKitLabels, objectLabels, foodLabels]);
    suggestedList = [
      ...foodLabels,
      ...objectLabels,
      ...mlKitLabels,
    ];

    return suggestedList;
  }
}
