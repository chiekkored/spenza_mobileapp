import 'package:cloud_firestore/cloud_firestore.dart';

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
}
