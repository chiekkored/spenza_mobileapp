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
      List<dynamic> stepsList,
      List<String> tags) async {
    List<Map<String, dynamic>> _ingredientText = [];
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
    // Upload images to Firebase Storage
    final storageRef = FirebaseStorage.instance.ref();
    try {
      for (var item in stepsList) {
        TextEditingController stepText = item[0];
        // Extract Paths from XFile List
        TextEditingController stepImage = item[1];
        DateTime now = DateTime.now();
        Reference storageRefDest = storageRef.child("posts/$uid/$now");
        if (stepImage.text != "") {
          await storageRefDest.putFile(File(stepImage.text));
          String imageUrl = await storageRefDest.getDownloadURL();
          _steps.add({"stepsText": stepText.text, "stepsImage": imageUrl});
        } else {
          _steps.add({"stepsText": stepText.text, "stepsImage": ""});
        }
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
            "postDateCreated": now,
            "ingredients": _ingredientText,
            "steps": _steps,
            "postTags": tags
          })
          .then((value) => true)
          .catchError((e) {
            debugPrint(e.toString());
            return false;
          });
      debugPrint("✅ [uploadRecipe] Success");
      return result;
    } on FirebaseException catch (e) {
      debugPrint("🛑 [uploadRecipe] Fail: ${e.message}");
      return false;
    }
  }

  Future<bool> uploadPantry(String uid, String coverPath, String foodName,
      String quantity, String unit) async {
    final storageRef = FirebaseStorage.instance.ref();
    try {
      DateTime now = DateTime.now();
      String imageUrl = "";
      if (coverPath != "") {
        Reference storageRefDest = storageRef.child("posts/$uid/$now");
        await storageRefDest.putFile(File(coverPath));
        imageUrl = await storageRefDest.getDownloadURL();
      }

      CollectionReference _usersPantry = FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("pantries");
      foodName = foodName.toLowerCase();
      bool result = await _usersPantry
          .add({
            "pantryFoodTitle":
                foodName.replaceFirst(foodName[0], foodName[0].toUpperCase()),
            "pantryQuantity": quantity,
            "pantryUnit": unit,
            "pantryImageUrl": imageUrl,
          })
          .then((value) => true)
          .catchError((e) {
            debugPrint(e.toString());
            return false;
          });
      debugPrint("✅ [uploadPantry] Success");
      return result;
    } on FirebaseException catch (e) {
      debugPrint("🛑 [uploadRecipe] Fail: ${e.message}");
      return false;
    }
  }

  Future<bool> uploadGrocery(String uid, String coverPath, String foodName,
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
      foodName.toLowerCase();
      foodName.replaceFirst(foodName[0], foodName[0].toUpperCase());
      bool result = await _usersPantry
          .add({
            "pantryFoodTitle": foodName,
            "pantryQuantity": quantity,
            "pantryUnit": unit,
            "pantryImageUrl": imageUrl,
          })
          .then((value) => true)
          .catchError((e) {
            debugPrint(e.toString());
            return false;
          });
      debugPrint("✅ [uploadGrocery] Success");
      return result;
    } on FirebaseException catch (e) {
      debugPrint("🛑 [uploadGrocery] Fail: ${e.message}");
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
      debugPrint("🗄 Downloaded Object-Labaler Model");
    }
    if (!await modelManager.isModelDownloaded(foodModelName)) {
      await FirebaseImageLabelerModelManager().downloadModel("Food");
      debugPrint("🗄 Downloaded Food Model");
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
      debugPrint("📚 [getSuggested] Response: $suggestedList");
    } catch (e) {
      debugPrint("🛑 [getSuggested] Error: ${e.toString()}");
    }
    return suggestedList;
  }
}
