import 'package:al_wahab/controller/constant.dart';
import 'package:flutter/material.dart';

class ProviderBookMark extends ChangeNotifier {
   double bookMarkOfOffset=Constants.bookMarkOfOffset;
   int bookMarkOfJuz=Constants.bookMarkOfJuz;
   void changeBookMark({int juz,double offset}){
     bookMarkOfOffset=offset;
     bookMarkOfJuz=juz;
     notifyListeners();
   }
}