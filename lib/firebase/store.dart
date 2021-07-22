import 'package:al_wahab/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

const String collectionOfUser = "users";
const String collectionOfNewConclusion = "newConclusion";

class Store {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  createConclusion() async {
    // await _store.collection(collectionPath)
  }

  addUser({name, email, String idOfUser}) async {
    await _store.collection(collectionOfUser).doc(idOfUser).set({
      UserInFireBase.name: name,
      UserInFireBase.email: email,
      UserInFireBase.idOfUser: idOfUser
    });
  }
  DocumentReference v;
  addNewConclusion({String name, String title,String wayToDivide,List <Map>readers}) async {
    v= await _store
        .collection(collectionOfNewConclusion)
        .add({
      Conclusion.name: name,
      Conclusion.title: title,
      Conclusion.wayToDivide: wayToDivide,
      Conclusion.admin: DataOfUser.nameInAppUser,
      Conclusion.idAdmin: DataOfUser.idOfUserInAppUser,
      Conclusion.emailAdmin:DataOfUser.emailInAppUser,
      Conclusion.readers:readers ,
    });
    return v;
  }
 Future<void> addNewReader({@required String docId,List reader})async{
    await _store
        .collection(collectionOfNewConclusion)
        .doc(docId).update({
      Conclusion.readers:reader
    });
  }

}
