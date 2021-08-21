import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:parkinsons_app/models/UserModel.dart';
import 'package:parkinsons_app/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on Firebase User
  UserModel? _userModelFromFirebaseUser(User? user) {
    if (user != null) {
      return UserModel(uid: user.uid);
    }
    return null;
  }

  //sign in with anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userModelFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential? result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DataBaseService(uid:user!.uid).updateUserData(email, password);
      return _userModelFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

//register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DataBaseService(uid:user!.uid).updateUserData(email, password);
      return _userModelFromFirebaseUser(user);
    } catch (e) {
      print("EXCEPTION BBBBB ${e.toString()}");
      return null;
    }
  }

//sign out
  Future signOut() async {
    try{
      return _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  User getCurrentUser(){
    return _auth.currentUser!;
  }
}
