import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/firebase/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserInFireBase{
  static String name='name';
  static String email='email';
  static String idOfUser='idOfUser';
}
class DataOfUser{
 static String nameInAppUser='';
 static String emailInAppUser='';
 static String idOfUserInAppUser='';
 static final FirebaseFirestore _firebaseFirestore=FirebaseFirestore.instance;
 static Future getDataOfUser()async{
return   _firebaseFirestore.collection(collectionOfUser).doc(DataOfUser.idOfUserInAppUser).get();
 }
  checkIfUserInIt({@required String docId})async{
   return  await _firebaseFirestore.collection(collectionOfNewConclusion)
       .doc(docId)
       .get();
 }
}
class Conclusion{
  static String title='title';
  static String name='name';
  static String wayToDivide='wayToDivide';
  static String admin='admin';
  static String idAdmin='idAdmin';
  static String emailAdmin='emailAdmin';
  static String readers='readers';
}
class Readers{
  static String name='name';
  static String id='id';
  static String email='email';
  static String willReading='willReading';

}