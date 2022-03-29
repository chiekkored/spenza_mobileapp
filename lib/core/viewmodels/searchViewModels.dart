import 'package:cloud_firestore/cloud_firestore.dart';

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

    // Get following lists
    return await _users.get().then((usersData) async {
      // For loop following users and get its userData
      for (var user in usersData.docs) {
        await _users.doc(user["uid"]).get().then((userData) async {
          _list.add(userData);

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
              // .where("postRecipeTitle", isEqualTo: searchText.toLowerCase())
              // .where("postRecipeTitle", isEqualTo: searchTextCapFirst)
              .get()
              .then((postsData) {
                _list.add(postsData);
                return _list;
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
          .then((value) => print("Search Added"))
          .catchError((error) => print("Failed to add user: $error"));
      ;
      return _list;
    });
  }

  Future<QuerySnapshot<Object?>> getSearchHistory(String uid) async {
    CollectionReference _usersSearch = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("search");

    return await _usersSearch.limit(10).get();
  }
}
