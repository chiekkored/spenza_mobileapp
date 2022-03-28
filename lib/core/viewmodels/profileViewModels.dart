import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileViewModel {
  Future<DocumentSnapshot<Map<String, dynamic>>> getDpUrl(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getRecipes(String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("recipes")
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFollowing(String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("following")
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFollowers(String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("followers")
        .get();
  }
}
