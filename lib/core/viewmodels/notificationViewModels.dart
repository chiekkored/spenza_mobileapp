import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NotificationViewModel {
  Future<List<dynamic>> getNotificationPosts(String uid) async {
    List<dynamic> list = [];
    List<String> postsId = [];
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return await users
        .doc(uid)
        .collection("notifications")
        .orderBy("dateCreated", descending: true)
        .get()
        .then((value) async {
      for (var notifData in value.docs) {
        if (notifData["type"] == "like") {
          // If type is like
          await users
              .doc(uid)
              .collection("posts")
              .doc(notifData["postDocId"])
              .collection("likes")
              .orderBy("dateCreated", descending: true)
              .get()
              .then((likesData) async {
            if (!postsId.contains(notifData["postDocId"])) {
              // Prevent multiple post likes if many
              if (likesData.docs.length > 1) {
                // If likes has many
                await users.doc(notifData["uid"]).get().then((authorData) {
                  return users
                      .doc(uid)
                      .collection("posts")
                      .doc(notifData["postDocId"])
                      .get()
                      .then((postData) async {
                    await users
                        .doc(likesData.docs[1].data()["uid"])
                        .get()
                        .then((authorData2) {
                      list.add([
                        notifData.data(),
                        authorData.data(),
                        postData.data(),
                        likesData.docs.length,
                        authorData2.data()
                      ]);
                      postsId.add(postData.id);
                    });
                  });
                });
              } else {
                // If likes has only one
                await users.doc(notifData["uid"]).get().then((authorData) {
                  return users
                      .doc(uid)
                      .collection("posts")
                      .doc(notifData["postDocId"])
                      .get()
                      .then((postData) {
                    list.add([
                      notifData.data(),
                      authorData.data(),
                      postData.data(),
                      1
                    ]);
                  });
                });
              }
            }
          });
        } else {
          // If type is follow
          await users.doc(notifData["uid"]).get().then((authorData) {
            list.add([notifData.data(), authorData.data()]);
          });
        }
      }
      list.sort((a, b) => b[0]["dateCreated"].compareTo(a[0]["dateCreated"]));
      debugPrint("📚 [getNotificationPosts] Success: $list");
      return list;
    });
  }
}
