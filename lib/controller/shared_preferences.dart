import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';

String lat = "LAT";
String long = "LONG";
String timeZone = "TIMEZONE";
String keyListOfZekr = 'LISTOFZEKR';
String login = "LOGIN";
String userUID = "USERUID";
String userName = "USERNAME";
String userEmail = "USEREMAIL";
String colorTheme = 'COLORTHEME';
String mainColor = 'MAINCOLOR';
String markOfJuz = 'JUZ';
String markOfOffset = 'OFFSET';

Future<void> saveDataOfUser({String userUid, String name, String email}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    await prefs.setString(userUID, userUid);
    await prefs.setString(userName, name);
    await prefs.setString(userEmail, email);
  } catch (e) {
    log("There is Error in SharedPreferences is $e");
  }
}

Future<void> saveLogIn({bool logn}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    await prefs.setBool(login, logn);
  } catch (e) {
    log("There is Error in SharedPreferences is $e");
  }
}

Future<void> saveLatLongAndTimeZone(
    {double latitude, double longitude, double TimeZone}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    await prefs.setDouble(lat, latitude);
    await prefs.setDouble(long, longitude);
    await prefs.setDouble(timeZone, TimeZone);
  } catch (e) {
    log("There is Error in SharedPreferences is $e");
  }
}

Future<void> saveListOfZekr({List<String> listOfZekr}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    await prefs.setStringList(keyListOfZekr, listOfZekr);
  } catch (e) {
    log("There is Error in SharedPreferences is $e");
  }
}

Future<void> saveColorTheme({bool showTheme}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    await prefs.setBool(colorTheme, showTheme);
  } catch (e) {
    log("There is Error in SharedPreferences is $e");
  }
}

Future<void> saveMainColor(int color) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    await prefs.setInt(mainColor, color);
  } catch (e) {
    log("There is Error in SharedPreferences is $e");
  }
}

Future<void> addBookMark({String id, int juz, double offset}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    log("markOfOffset id is $markOfOffset $id");
    await prefs.setInt("$markOfJuz $id", juz);
    await prefs.setDouble("$markOfOffset $id", offset);
  } catch (e) {
    log("There is Error in SharedPreferences is $e");
  }
}

Future<void> getBookMark({@required String id}) async {
  log("id is $markOfOffset $id");
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    Constants.bookMarkOfOffset = prefs.getDouble("$markOfOffset $id");
    Constants.bookMarkOfJuz = prefs.getInt("$markOfJuz $id");
    log("Constants.bookMarkOfOffset is ${prefs.getDouble("$markOfOffset $id")}");
  } catch (e) {
    log("There is Error in SharedPreferences is $e");
  }
}
