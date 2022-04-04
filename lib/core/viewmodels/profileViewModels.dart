import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileViewModel {
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(String uid) async {
    return await FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getRecipes(String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("posts")
        .get();
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
      String profileDpUrl) async {
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
                .doc(profileUid)
                .set({
              "uid": profileUid,
              "name": profileName,
              "dpUrl": profileDpUrl
            }).then((value) {
              print("[Success] Follow: $profileName");
              return true;
            }))
        .catchError((error) {
          print("Failed to add follwing: $error");
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
                .where("uid", isEqualTo: uid)
                .get()
                .then((value) => FirebaseFirestore.instance
                    .collection('users')
                    .doc(profileUid)
                    .collection("followers")
                    .doc(docId)
                    .delete())
                .then((value) {
              print("[Success] Unfollow: $profileUid");
              return true;
            }))
        .catchError((error) {
      print("Failed to unfollow: $error");
      return false;
    });
  }
}
