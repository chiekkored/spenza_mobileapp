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
      List<dynamic> ingredientList,
      List<TextEditingController> stepsList,
      List<XFile?> imagesList,
      List<String> tags) async {
    int stepsCount = 0;
    List<Map<String, dynamic>> _ingredientText = [];
    List<String> _imagesPath = [];
    List<Map<String, dynamic>> _steps = [];
    String coverUrl;

    // Extract Texts from TextEditingController List
    for (List<TextEditingController> item in ingredientList) {
      _ingredientText.add({
        "ingredientQty": item[0].text,
        "ingredientUnit": item[1].text,
        "ingredientText": item[2].text
      });
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

      CollectionReference _usersPosts = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("posts");
      bool result = await _usersPosts
          .add({
            "postRecipeTitle": foodName.toLowerCase(),
            "postDuration": "${cookingDuration.round().toString()} mins",
            "postDescription": description,
            "authorUid": uid,
            "postImageUrl": coverUrl,
            "postPercent": "80%",
            "postDateCreated": now,
            "ingredients": _ingredientText,
            "steps": _steps
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
    final modelManager = FirebaseImageLabelerModelManager();
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final objectLabelerModelName = "Object-Labeler";
    final foodModelName = "Food";

    // TEXT RECOGNITION
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    List<ImageLabel> textToImageLabelModel = [];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        textToImageLabelModel
            .add(ImageLabel(confidence: 0, label: line.text, index: 0000));
      }
    }

    // Image Labeling
    // Download Custom Models
    if (!await modelManager.isModelDownloaded(objectLabelerModelName)) {
      await modelManager.downloadModel("Object-Labeler");
      print("Downloaded Object-Labaler Model");
    }
    if (!await modelManager.isModelDownloaded(foodModelName)) {
      await FirebaseImageLabelerModelManager().downloadModel("Food");
      print("Downloaded Food Model");
    }
    final objectLabelerModelOptions = FirebaseLabelerOption(
        confidenceThreshold: 0.5, modelName: objectLabelerModelName);
    final foodModelOptions = FirebaseLabelerOption(
        confidenceThreshold: 0.5, modelName: foodModelName);

    // Initialize Image Labeler
    final imagePDModel = ImageLabeler(options: ImageLabelerOptions());
    final imageLabelerOLModel =
        ImageLabeler(options: objectLabelerModelOptions);
    final imageLabelerFModel = ImageLabeler(options: foodModelOptions);

    // Process Image Labeling
    try {
      final List<ImageLabel> mlKitLabels =
          await imagePDModel.processImage(inputImage);
      final List<ImageLabel> objectLabels =
          await imageLabelerOLModel.processImage(inputImage);
      final List<ImageLabel> foodLabels =
          await imageLabelerFModel.processImage(inputImage);

      // Combine into an array
      suggestedList = [
        ...textToImageLabelModel,
        ...foodLabels,
        ...objectLabels,
        ...mlKitLabels,
      ];
      print("Suggested lIST: $suggestedList");
    } catch (e) {
      print("Error processing image: ${e.toString()}");
    }
    return suggestedList;
  }
}
