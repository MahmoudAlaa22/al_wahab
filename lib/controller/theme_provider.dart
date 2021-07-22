import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import 'constant.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
bool showDark=false;
  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }
int co;
  void toggleTheme(bool isOn) {
    log("isOn is $isOn");
    showDark=isOn;
    Constants.colorThemes=isOn;
    themeMode = showDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
  changeColor({int color}){
    co=color;
    log("cococococo ${Color(co)}");
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.black,
    colorScheme: ColorScheme.dark(),
    iconTheme: IconThemeData(color: Color(Constants.mainColor)),
    accentColor: Color(Constants.mainColor),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(Constants.mainColor)
    ),
    appBarTheme: AppBarTheme(
        color: Colors.black,
        iconTheme: IconThemeData(
            color: Color(Constants.mainColor)
        )
    ),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light(),
    iconTheme: IconThemeData(color: Color(Constants.mainColor)),
  accentColor: Color(Constants.mainColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(Constants.mainColor)
      ),
      appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(
              color: Color(Constants.mainColor)
          )
      ),
  );
}

