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
      'Email': email,
      'Password': Crypt.sha256(password).toString(),
    });
  }

  Future updateUserRythmGame(
      int score, double pixelsFromCenter, String medicineAnswer) async {
    return await userCollection
        .doc(uid)
        .collection("Rhythm Test")
        .doc(createTimeStamp())
        .set({
      'Medicine Answer': medicineAnswer,
      'Score': score,
      'Total Pixels From Center': pixelsFromCenter
    });
  }

  Future updateUserMemoryGame(int tries, int difficulty, bool gameFinished,
      String medicineAnswer) async {
    return await userCollection
        .doc(uid)
        .collection("Memory Game")
        .doc(createTimeStamp())
        .set({
      'Medicine Answer': medicineAnswer,
      'Tries': tries,
      'Difficulty': difficulty,
      'Game Finished': gameFinished
    });
  }

  Future updateGeneric(String collectionName, String medicineAnswer) async {
    return await userCollection
        .doc(uid)
        .collection(collectionName)
        .doc(createTimeStamp())
        .set({"Medicine Answer": medicineAnswer});
  }

  Future uploadFile(File file, String folderName, String filetype) async {
    String timeStamp = createTimeStamp();
    try {
      await FirebaseStorage.instance
          .ref(uid + '/' + folderName)
          .child(timeStamp + filetype)
          .putFile(file);
    } catch (e) {
      print(e);
    }

    // e.g, e.code == 'canceled'
  }
}
