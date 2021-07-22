import 'dart:developer';

import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/shared_preferences.dart';
import 'package:al_wahab/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> createUserWithEmailAndPassword({String email, String password}) async {
    try {
      DataOfUser.idOfUserInAppUser = (await _auth.createUserWithEmailAndPassword(email: email, password: password)).user.uid;
     log('Signed in signInWithEmailAndPassword as user ${DataOfUser.idOfUserInAppUser}');

    } catch (e) {
      log('Failed to sign in signInWithEmailAndPassword');
    }
  }
  Future<void> signInWithEmailAndPassword({String email,String password}) async {
    try {
      DataOfUser.idOfUserInAppUser = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user.uid;
      DataOfUser.emailInAppUser=email;
    } catch (e) {
      log('Failed to sign in signInWithEmailAndPassword');
    }
  }
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      saveDataOfUser(userUid: '',name: '',email: '');
      addBookMark(id: '',juz: null,offset: null);
      DataOfUser.idOfUserInAppUser='';
      DataOfUser.nameInAppUser='';
      DataOfUser.emailInAppUser='';
    } catch (e) {
      log('Failed to sign in signInWithEmailAndPassword');
    }
  }
}
