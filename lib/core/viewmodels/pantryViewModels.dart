import 'package:cloud_firestore/cloud_firestore.dart';

class PantryViewModel {
  Future<QuerySnapshot> getPantries(String uid) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("pantries")
        .get();
  }
}
