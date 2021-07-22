import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangeTime extends ChangeNotifier{
String timeString="00 : 00";
List<String>listOfAzkar=[];
// ['سبحان الله و بحمده - 33','لا حول ولا قوة إلا بالله - 33',
//   'اللهم صل علي سيدنا محمد و علي اله و صحبه و سلم - 100','أستغفر الله العظيم - 1000'
// ];

void stringTimeChange(String text){
  timeString=text;
  notifyListeners();
}
  void getListOfAzkar({List<String> list}){
  listOfAzkar=list;
  notifyListeners();
}
  void getDeleteListOfAzkar(int index){
  listOfAzkar.removeAt(index);
  notifyListeners();
}
}