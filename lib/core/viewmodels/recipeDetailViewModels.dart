import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeDetailsViewModel {
  Future<QuerySnapshot> getLikes(String postDocId, String profileUid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(profileUid)
        .collection("posts")
        .doc(postDocId)
        .collection("likes")
        .get();
  }

  Future<DocumentSnapshot> getRecipeDetails(
      String postDocId, String profileUid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(profileUid)
        .collection("posts")
        .doc(postDocId)
        .get();
  }

  Future<QuerySnapshot> getIfPantryExist(String uid, String ingredient) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("pantries")
        .where("pantryFoodTitle", isEqualTo: ingredient)
        .limit(1)
        .get();
  }

  Future<QuerySnapshot> getIfGroceryExist(String uid, String ingredient) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("groceries")
        .where("groceryFoodTitle", isEqualTo: ingredient)
        .limit(1)
        .get();
  }

  Future<bool> addToGrocery(String uid, List ingredients) async {
    CollectionReference _userGrocery = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("groceries");
    try {
      for (Map<String, dynamic> ingredient in ingredients) {
        QuerySnapshot pantryData =
            await getIfPantryExist(uid, ingredient["ingredientText"]);
        QuerySnapshot groceryData =
            await getIfGroceryExist(uid, ingredient["ingredientText"]);
        if (groceryData.docs.isNotEmpty &&
            groceryData.docs.first["groceryIsDone"] == false) {
          QueryDocumentSnapshot grocery = groceryData.docs.first;
          if (pantryData.docs.isNotEmpty) {
            QueryDocumentSnapshot pantry = pantryData.docs.first;
            if (int.parse(pantry["pantryQuantity"]) <
                int.parse(ingredient["ingredientQty"])) {
              _userGrocery
                  .doc(grocery.id)
                  .update({
                    'groceryFoodTitle': ingredient["ingredientText"],
                    'groceryImageUrl': pantry["pantryImageUrl"],
                    'groceryQuantity':
                        "${int.parse(grocery["groceryQuantity"]) + (int.parse(ingredient["ingredientQty"]) - int.parse(pantry["pantryQuantity"]))}",
                    'groceryUnit': ingredient["ingredientUnit"],
                  })
                  .whenComplete(
                      () => debugPrint("✅ [addToGrocery] Grocery Added"))
                  .catchError((e) {
                    debugPrint(e.toString());
                  });
            }
          } else {
            _userGrocery
                .doc(grocery.id)
                .update({
                  'groceryFoodTitle': ingredient["ingredientText"],
                  'groceryImageUrl': grocery["groceryImageUrl"],
                  'groceryQuantity':
                      "${int.parse(grocery["groceryQuantity"]) + (int.parse(ingredient["ingredientQty"]))}",
                  'groceryUnit': ingredient["ingredientUnit"],
                })
                .whenComplete(
                    () => debugPrint("✅ [addToGrocery] Grocery Added"))
                .catchError((e) {
                  debugPrint(e.toString());
                });
          }
        } else {
          if (pantryData.docs.isNotEmpty) {
            QueryDocumentSnapshot pantry = pantryData.docs.first;

            _userGrocery
                .add({
                  'groceryFoodTitle': ingredient["ingredientText"],
                  'groceryIsDone': false,
                  'groceryImageUrl':
                      "https://firebasestorage.googleapis.com/v0/b/spenza-recipe-app.appspot.com/o/placeholders%2Ficon.png?alt=media&token=18603a2b-2386-48e3-ae79-d11d8adaef52",
                  'groceryQuantity':
                      "${int.parse(ingredient["ingredientQty"]) - int.parse(pantry["pantryQuantity"])}",
                  'groceryUnit': ingredient["ingredientUnit"],
                })
                .whenComplete(
                    () => debugPrint("✅ [addToGrocery] Grocery Added"))
                .catchError((e) {
                  debugPrint(e.toString());
                });
          } else {
            _userGrocery
                .add({
                  'groceryFoodTitle': ingredient["ingredientText"],
                  'groceryIsDone': false,
                  'groceryImageUrl':
                      "https://firebasestorage.googleapis.com/v0/b/spenza-recipe-app.appspot.com/o/placeholders%2Ficon.png?alt=media&token=18603a2b-2386-48e3-ae79-d11d8adaef52",
                  'groceryQuantity': ingredient["ingredientQty"],
                  'groceryUnit': ingredient["ingredientUnit"],
                })
                .whenComplete(
                    () => debugPrint("✅ [addToGrocery] Grocery Added"))
                .catchError((e) {
                  debugPrint(e.toString());
                });
          }
        }
      }
      return true;
    } catch (e) {
      debugPrint("🛑 [addToGrocery] Add Error: ${e.toString()}");
      return false;
    }
  }
}
