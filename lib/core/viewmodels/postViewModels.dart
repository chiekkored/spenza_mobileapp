import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/providers/filterProvider.dart';

class PostViewModel {
  Future<List<dynamic>> getProfileLikes(String uid) async {
    // _list[0] = user collection
    // _list[1] = user posts collection
    List<dynamic> _list = [];

    CollectionReference _users = FirebaseFirestore.instance.collection("users");
    CollectionReference _usersLikes = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("likes");

    QuerySnapshot<Map<String, dynamic>> pantries = await _users
        .doc(uid)
        .collection("pantries")
        .get()
        .then((pantryData) async => pantryData);

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
            List ingredients = postsData.data()!["ingredients"];
            num postPercent = percentCalculate(pantries, ingredients);
            Map<String, dynamic>? postData = postsData.data();
            postData!["postPercent"] = "${postPercent.toStringAsFixed(0)}%";

            _list.add([userData.data(), postData, postsData.id]);
          });
        });
      }
      debugPrint("📚 [getProfileLikes] Response: $_list");
      return _list;
    });
  }

  Future<List<Map<String, dynamic>>> getProfilePosts(String uid) async {
    List<Map<String, dynamic>> _list = [];
    CollectionReference _users = FirebaseFirestore.instance.collection("users");

    QuerySnapshot<Map<String, dynamic>> pantries = await _users
        .doc(uid)
        .collection("pantries")
        .get()
        .then((pantryData) async => pantryData);

    return await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("posts")
        .get()
        .then((postsData) {
      for (var post in postsData.docs) {
        List ingredients = post["ingredients"];
        num postPercent = percentCalculate(pantries, ingredients);
        Map<String, dynamic> postData = post.data();
        postData["postPercent"] = "${postPercent.toStringAsFixed(0)}%";
        postData["id"] = post.id;
        _list.add(postData);
      }
      debugPrint("📚 [getProfilePosts] Response: $_list");
      return _list;
    });
  }

  double percentCalculate(
      QuerySnapshot<Map<String, dynamic>> pantries, List<dynamic> ingredients) {
    Iterable ingredient = ingredients.map(
      (e) => e["ingredientText"],
    );
    Iterable pantry = pantries.docs.map((e) => e["pantryFoodTitle"]);
    return (pantry
                .where((pantryItem) => ingredient.contains(pantryItem))
                .length /
            ingredients.length) *
        100;
  }

  Future<List<dynamic>> getPosts(
      String uid, FilterProvider filterProvider) async {
    // _list[0] = user collection
    // _list[1] = user posts collection
    List<dynamic> _list = [];

    CollectionReference _users = FirebaseFirestore.instance.collection("users");
    CollectionReference _usersFollowing = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("following");

    QuerySnapshot<Map<String, dynamic>> pantries = await _users
        .doc(uid)
        .collection("pantries")
        .get()
        .then((pantryData) async => pantryData);

    // Get following lists
    await _usersFollowing.get().then((followingData) async {
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
              List ingredients = post["ingredients"];
              num postPercent = percentCalculate(pantries, ingredients);
              Map<String, dynamic> postData = post.data();
              postData["postPercent"] = "${postPercent.toStringAsFixed(0)}%";
              _list.add([userData.data(), postData, post.id]);
            }
          });
        });
      }
    });

    if (filterProvider.tag != "" &&
        filterProvider.cookingDuration != 0.0 &&
        filterProvider.ingredientOnHand != 0.0) {
      var _filtered = [];
      for (List item in _list) {
        List postTags = item[1]["postTags"];
        String postPercentToString = item[1]["postPercent"];
        String postDurationToString = item[1]["postDuration"];
        if ((filterProvider.tag != ""
                ? postTags.contains(filterProvider.tag)
                : true) &&
            filterProvider.ingredientOnHand >=
                double.parse(postPercentToString.replaceAll("%", "")) &&
            filterProvider.cookingDuration >=
                double.parse(postDurationToString.replaceAll(" mins", ""))) {
          _filtered.add(item);
        }
      }
      _list.clear();
      _list.addAll(_filtered);
    }
    return _list;
  }

  Future<List<dynamic>> getAllPosts(String uid) async {
    // _list[0] = user collection
    // _list[1] = user posts collection
    List<dynamic> _list = [];

    CollectionReference _users = FirebaseFirestore.instance.collection("users");

    QuerySnapshot<Map<String, dynamic>> pantries = await _users
        .doc(uid)
        .collection("pantries")
        .get()
        .then((pantryData) async => pantryData);

    // Get following lists
    return await _users.get().then((users) async {
      // For loop following users and get its userData
      for (var user in users.docs) {
        await _users.doc(user["uid"]).get().then((userData) async {
          // Get users' posts
          return await _users
              .doc(user["uid"])
              .collection("posts")
              .get()
              .then((postsData) {
            for (var post in postsData.docs) {
              List ingredients = post["ingredients"];
              num postPercent = percentCalculate(pantries, ingredients);
              Map<String, dynamic> postData = post.data();
              postData["postPercent"] = "${postPercent.toStringAsFixed(0)}%";
              _list.add([userData.data(), postData, post.id]);
            }
          });
        });
      }
      _list.sort(
          (a, b) => b[1]["postDateCreated"].compareTo(a[1]["postDateCreated"]));

      debugPrint("📚 [getAllPosts] Response: $_list");
      return _list;
    });
  }

  Future<bool> likePost(String profileUid, String postDocId, String userUid,
      String userName, String userDpUrl) async {
    DateTime now = new DateTime.now();
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
                  debugPrint("✅ [likePost] Success: $userName");
                  return true;
                }))
            .catchError((error) {
              debugPrint("🛑 [likePost] Fail: $error");
              return false;
            }))
        .catchError((error) {
          debugPrint("🛑 [likePost] Fail: $error");
          return false;
        });
  }

  Future<bool> unlikePost(
      String profileUid, String postDocId, String userUid) async {
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
                      debugPrint("✅ [unlikePost] Success: $postDocId");
                      return true;
                    }))
                .catchError((error) {
              debugPrint("🛑 [unlikePost] Fail: $error");
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
