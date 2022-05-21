import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/viewmodels/postViewModels.dart';

class SearchViewModel {
  Future<List<dynamic>> getSearch(String searchText, String uid) async {
    // _list[0] = user collection
    // _list[1] = user posts collection
    List<dynamic> _list = [];

    CollectionReference _users = FirebaseFirestore.instance.collection('users');
    CollectionReference _usersSearch = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("search");

    QuerySnapshot<Map<String, dynamic>> pantries = await _users
        .doc(uid)
        .collection("pantries")
        .get()
        .then((pantryData) async => pantryData);

    // Get all users
    return await _users.get().then((usersData) async {
      // For loop all users and get its userData
      for (var user in usersData.docs) {
        await _users.doc(user["uid"]).get().then((userData) async {
          // Capital First Letter
          var searchTextCapFirst = searchText
              .replaceFirst(searchText[0], searchText[0].toUpperCase())
              .toString();
          // Get users' posts
          return await _users
              .doc(user["uid"])
              .collection("posts")
              .where("postRecipeTitle", whereIn: [
                searchText,
                searchText.toLowerCase(),
                searchTextCapFirst
              ])
              .get()
              .then((postsData) {
                for (var post in postsData.docs) {
                  List ingredients = post["ingredients"];
                  num postPercent =
                      (pantries.docs.length / ingredients.length) * 100;
                  Map<String, dynamic> postData = post.data();
                  postData["postPercent"] =
                      "${postPercent.toStringAsFixed(0)}%";
                  _list.add([userData.data(), postData, post.id]);
                }
              });
        });
      }
      // Add to firestore search document
      DateTime now = new DateTime.now();
      await _usersSearch
          .add({
            'searchText': searchText,
            'date_created': now,
          })
          .then((value) => debugPrint("✅ [getSearch] Search Added"))
          .catchError((error) => debugPrint("🛑 [getSearch] Search Add Error"));

      debugPrint("📚 [getSearch] Response: $_list");
      return _list;
    });
  }

  Future<QuerySnapshot<Object?>> getSearchHistory(String uid) async {
    CollectionReference _usersSearch = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("search");

    debugPrint("📚 [getSearchHistory] Response: $_usersSearch");
    return await _usersSearch.limit(10).get();
  }
}
