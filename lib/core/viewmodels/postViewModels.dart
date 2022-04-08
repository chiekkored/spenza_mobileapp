import 'package:cloud_firestore/cloud_firestore.dart';

class PostViewModel {
  Future<List<dynamic>> getProfileLikes(String uid) async {
    // _list[0] = user collection
    // _list[1] = user posts collection
    List<dynamic> _list = [];

    print("UID: $uid");

    CollectionReference _users = FirebaseFirestore.instance.collection("users");
    CollectionReference _usersLikes = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("likes");

    // Get following lists
    return await _usersLikes.get().then((likesData) async {
      // For loop following users and get its userData
      for (var likes in likesData.docs) {
        await _users.doc(likes["profileUid"]).get().then((userData) async {
          // Get users' posts
          return await _users
              .doc(likes["profileUid"])
              .collection("posts")
              .doc(likes["postDocId"])
              .get()
              .then((postsData) {
            _list.add([userData.data(), postsData.data(), postsData.id]);
          });
        });
      }
      print(_list);
      return _list;
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getProfilePosts(
      String uid) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("posts")
        .get();
  }

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
              _list.add([userData.data(), post.data(), post.id]);
            }
          });
        });
      }
      print(_list);
      return _list;
    });
  }

  Future<bool> likePost(String profileUid, String postDocId, String userUid,
      String userName, String userDpUrl) async {
    DateTime now = new DateTime.now();
    print("profileUid: $profileUid");
    print("postDocId: $postDocId");
    print("userUid: $userUid");
    print("userName: $userName");
    print("userDpUrl: $userDpUrl");
    return await FirebaseFirestore.instance // Add document for posts likes
        .collection('users')
        .doc(profileUid)
        .collection("posts")
        .doc(postDocId)
        .collection("likes")
        .doc(userUid)
        .set({
          "uid": userUid,
          "name": userName,
          "dateCreated": now,
          "dpUrl": userDpUrl
        })
        .then((value) => FirebaseFirestore
            .instance // Add document inside profile's notifications
            .collection('users')
            .doc(profileUid)
            .collection("notifications")
            .add({
              "uid": userUid,
              "dateCreated": now,
              "type": "like",
              "postDocId": postDocId
            })
            .then((value) => FirebaseFirestore
                    .instance // Add document for user's likes
                    .collection('users')
                    .doc(userUid)
                    .collection("likes")
                    .doc(postDocId)
                    .set({
                  "profileUid": profileUid,
                  "dateCreated": now,
                  "postDocId": postDocId
                }).then((value) {
                  print("[Success] Liked: $userName");
                  return true;
                }))
            .catchError((error) {
              print("Failed to add like: $error");
              return false;
            }))
        .catchError((error) {
          print("Failed to add like: $error");
          return false;
        });
  }

  Future<bool> unlikePost(String profileUid, String postDocId, String userUid,
      String likeDocId) async {
    DateTime now = new DateTime.now();

    return await FirebaseFirestore.instance // Delete document for posts likes
        .collection('users')
        .doc(profileUid)
        .collection("posts")
        .doc(postDocId)
        .collection("likes")
        .doc(userUid)
        .delete()
        .then((value) => FirebaseFirestore
                .instance // Get document inside profile's notifications
                .collection('users')
                .doc(profileUid)
                .collection("notifications")
                .where("postDocId", isEqualTo: postDocId)
                .where("type", isEqualTo: "like")
                .where("uid", isEqualTo: userUid)
                .limit(1)
                .get()
                .then((value) => value.docs.first.reference
                    .delete()) // Delete document inside profile's notifications
                .then((value) => FirebaseFirestore
                        .instance // Delete document for user's likes
                        .collection('users')
                        .doc(userUid)
                        .collection("likes")
                        .doc(postDocId)
                        .delete()
                        .then((value) {
                      print("[Success] Unliked: $postDocId");
                      return true;
                    }))
                .catchError((error) {
              print("Failed to add like: $error");
              return false;
            }));
  }

  Stream<QuerySnapshot> getIfPostLiked(String uid, String postDocId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("likes")
        .where("postDocId", isEqualTo: postDocId)
        .limit(1)
        .snapshots();
  }
}
