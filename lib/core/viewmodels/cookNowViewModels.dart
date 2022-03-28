import 'package:cloud_firestore/cloud_firestore.dart';

class CookNowViewModel {
  Future<List<dynamic>> getPosts(String uid) async {
    // _list[0] = user collection
    // _list[1] = user posts collection
    List<dynamic> _list = [];

    // Get following lists
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("following")
        .get()
        .then((followingData) async {
      // For loop following users and get its userData
      for (var user in followingData.docs) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user["uid"])
            .get()
            .then((userData) async {
          _list.add(userData);

          // Get users' posts
          return await FirebaseFirestore.instance
              .collection('users')
              .doc(user["uid"])
              .collection("posts")
              .get()
              .then((postsData) {
            _list.add(postsData);
            print(_list);
            return _list;
          });
        });
      }
      return _list;
    });
  }
}
