import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CookNowViewModel {
  Future<List<dynamic>> getPosts(String uid) async {
    // _list[0] = user collection
    // _list[1] = user posts collection
    List<dynamic> _list = [];

    print("UID: $uid");

    CollectionReference _users = FirebaseFirestore.instance.collection("users");
    CollectionReference _usersFollowing = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("following");

    // Get following lists
    return await _usersFollowing.get().then((followingData) async {
      // For loop following users and get its userData
      for (var user in followingData.docs) {
        await _users.doc(user["uid"]).get().then((userData) async {
          // Get users' posts
          return await _users
              .doc(user["uid"])
              .collection("posts")
              .get()
              .then((postsData) {
            for (var post in postsData.docs) {
              _list.add([userData.data(), post.data()]);
            }
          });
        });
      }
      print(_list);
      return _list;
    });
    // return _usersFollowing.snapshots().asyncMap((event) {
    //   for (var user in event.docs) {
    //     _users.doc(user["uid"]).get().then((userData) async {
    //       // Get users' posts
    //       return await _users
    //           .doc(user["uid"])
    //           .collection("posts")
    //           .get()
    //           .then((postsData) {
    //         for (var post in postsData.docs) {
    //           _list.add([userData.data(), post.data()]);
    //         }
    //       });
    //     });
    //   }
    //   return _list;
    // });
  }
}
