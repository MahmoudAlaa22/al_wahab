import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/shared_preferences.dart';
import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/veiws/home.dart';

import '../main.dart';
import '../test1.dart';


class ChangeThemeButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    return Switch.adaptive(
      value: themeProvider.isDarkMode,
      activeColor: Color(Constants.mainColor),
      onChanged: (value)async {
        saveColorTheme(showTheme: value);
        // final provider = Provider.of<ThemeProvider>(context, listen: false);
        themeProvider.toggleTheme(value);
        // Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (_)=>Waite())
        // );
        log("GGHGHGHGHG");
        Future.delayed(const Duration(seconds:1 ), () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_)=>MyApp())
          );
        });


      },
    );
  }
}
