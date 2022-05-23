import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spenza/core/providers/filterProvider.dart';
import 'package:spenza/core/viewmodels/postViewModels.dart';

class SearchViewModel {
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

  Future<List<dynamic>> getSearch(
      String searchText, String uid, FilterProvider filterProvider) async {
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
          // Get users' posts based on search query
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
                  num postPercent = percentCalculate(pantries, ingredients);
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

      // Filter search based on given filter
      if (true) {
        List _filtered = [];
        for (List item in _list) {
          List postTags = item[1]["postTags"];
          String postPercentToString = item[1]["postPercent"];
          String postDurationToString = item[1]["postDuration"];
          if ((filterProvider.tag != ""
                  ? postTags.contains(filterProvider.tag)
                  : true) &&
              (filterProvider.cookingDuration != 0.0
                  ? filterProvider.ingredientOnHand >=
                      double.parse(postPercentToString.replaceAll("%", ""))
                  : true) &&
              (filterProvider.ingredientOnHand != 0.0
                  ? filterProvider.cookingDuration >=
                      double.parse(postDurationToString.replaceAll(" mins", ""))
                  : true)) {
            _filtered.add(item);
          }
        }
        _list.clear();
        _list.addAll(_filtered);
      }
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
