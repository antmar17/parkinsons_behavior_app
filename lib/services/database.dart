import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:crypt/crypt.dart';
import 'package:parkinsons_app/services/Util.dart';

class DataBaseService {
  final String uid;

  DataBaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('UserAccount');

  Future updateUserData(String email, String password) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'password': Crypt.sha256(password).toString(),
    });
  }

  Future updateUserRythmGame(int score, double pixelsFromCenter) async {
    return await userCollection
        .doc(uid)
        .collection("RythmGame")
        .doc(createTimeStamp())
        .set({'score': score, 'pixelsFromCenter': pixelsFromCenter});
  }

  Future updateUserMemoryGame(
      int tries, int difficulty, bool gameFinished) async {
    return await userCollection
        .doc(uid)
        .collection("MemoryGame")
        .doc(createTimeStamp())
        .set({
      'tries': tries,
      'difficulty': difficulty,
      'gameFinished': gameFinished
    });
  }

  Future<void> uploadFile(File file,String folderName,String filetype) async {
    try {
      await FirebaseStorage.instance
          .ref(uid + '/' + folderName)
          .child(createTimeStamp()+filetype)
          .putFile(file);
    } catch (e) {
      print(e);
    }
    // e.g, e.code == 'canceled'
  }
}
