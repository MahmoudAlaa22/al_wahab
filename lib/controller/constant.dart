import 'dart:developer';

import 'package:flutter/material.dart';

double height = 0.0, width = 0.0;

setScreenOfHeight(double h) => height = h;

double get getScreenOfHeight => height;

setScreenOfWidth(double w) => width = w;

double get getScreenOfWidth => width;

class Constants {
  static int mainColor;
  static Color sceColor = Colors.white;
  static bool colorThemes;
  static List nameOfPrayLise = [
    'الفجر',
    'الشروق',
    'الظهر',
    'العصر',
    'الغروب',
    'المغرب',
    'العشاء'
  ];
  static double lat;

  static double long;

  static double timeZone;

  static List<String> listOfZekr = [];
  static double bookMarkOfOffset;
  static int bookMarkOfJuz;
  static String massageOfValidator = "This field should not be empty";
  static String idOfConclusionPrivate = 'الختمات السابقة';
  static String idOfConclusionPuplic = 'الختمات العامة';

  void test() =>log("test");
}

const int colorMain = 0xff4caf50;
const String basmala = "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ";
