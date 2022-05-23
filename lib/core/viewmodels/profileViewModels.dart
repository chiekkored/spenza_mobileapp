import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileViewModel {
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<bool> deletePantry(String uid, String docId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("pantries")
        .doc(docId)
        .delete()
        .then((value) => true)
        .catchError((error) {
      debugPrint("🛑 [deletePantry] Fail: $error");
      return false;
    });
  }

  Future<bool> deleteGrocery(String uid, String docId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("groceries")
        .doc(docId)
        .delete()
        .then((value) => true)
        .catchError((error) {
      debugPrint("🛑 [deleteGrocery] Fail: $error");
      return false;
    });
  }

  Future<bool> toggleGroceryItem(String uid, String docId, bool value) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("groceries")
        .doc(docId)
        .update({"groceryIsDone": value})
        .then((value) => true)
        .catchError((error) {
          debugPrint("🛑 [checkGroceryItem] Fail: $error");
          return false;
        });
  }

  Stream<QuerySnapshot> getGroceries(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("groceries")
        .snapshots();
  }

  Stream<QuerySnapshot> getPantries(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("pantries")
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRecipes(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("posts")
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getIsFollowing(
      String uid, String profileUid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("following")
        .where("uid", isEqualTo: profileUid)
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowing(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("following")
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowers(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("followers")
        .snapshots();
  }

  Future<bool> setFollow(String uid, String profileUid, String profileName,
      String profileDpUrl, String userName, String userDpUrl) async {
    DateTime now = new DateTime.now();
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("following")
        .doc(profileUid)
        .set({"uid": profileUid, "name": profileName, "dpUrl": profileDpUrl})
        .then((value) => FirebaseFirestore.instance
            .collection('users')
            .doc(profileUid)
            .collection("followers")
            .doc(uid)
            .set({"uid": uid, "name": userName, "dpUrl": userDpUrl})
            .then((value) => FirebaseFirestore.instance
                .collection('users')
                .doc(profileUid)
                .collection("notifications")
                .add({"type": "follow", "dateCreated": now, "uid": uid}))
            .then((value) {
              debugPrint("✅ [setFollow] Success: $profileName");
              return true;
            }))
        .catchError((error) {
          debugPrint("🛑 [setFollow] Fail: $error");
          return false;
        });
  }

  Future<bool> setUnfollow(String uid, String profileUid, String docId) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("following")
        .doc(docId)
        .delete()
        .then((value) => FirebaseFirestore.instance
                .collection('users')
                .doc(profileUid)
                .collection("followers")
                .doc(uid)
                .delete()
                .then((value) => FirebaseFirestore
                    .instance // Get document inside profile's notifications
                    .collection('users')
                    .doc(profileUid)
                    .collection("notifications")
                    .where("type", isEqualTo: "follow")
                    .where("uid", isEqualTo: uid)
                    .limit(1)
                    .get()
                    .then((value) => value.docs.first.reference.delete()))
                .then((value) {
              debugPrint("✅ [setUnfollow] Success: $profileUid");
              return true;
            }))
        .catchError((error) {
      debugPrint("🛑 [setUnfollow] Fail: $error");
      return false;
    });
  }
}
