
import 'dart:developer';

import 'package:al_wahab/veiws/test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:al_wahab/controller/provider.dart';
import 'package:al_wahab/controller/shared_preferences.dart';
import 'package:al_wahab/veiws/home.dart';

import 'controller/constant.dart';
import 'controller/get_data/get_quran_data.dart';
import 'controller/provider_book_mark.dart';
import 'controller/quran_api.dart';
import 'controller/theme_provider.dart';
import 'model/user.dart';
//com.example.al_wahab

final FlutterLocalNotificationsPlugin fltrNotification=
FlutterLocalNotificationsPlugin();
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  var androidInitilize =  AndroidInitializationSettings('@mipmap/ic_launcher');
  var iOSinitilize =  IOSInitializationSettings();
  var initilizationsSettings =
  InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
  fltrNotification.initialize(initilizationsSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          log('notification payload: $payload' );
        }
      }
  );
  QuranApi.getAudioOfSurah().then((value) => GetQuranData.quranAudio=value);
  QuranApi.getAudioOfAyah().then((value) => GetQuranData.quranAudioAyah=value);
  await Firebase.initializeApp().then((value) => log("True True"));
  SharedPreferences preferences=await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
log("preferences.getBool(login) is ${preferences.getString(userUID)}");
// if(preferences.getString(userUID)!=null&&preferences.getString(userUID).isNotEmpty){
  // Constants.userUid=preferences.getString(userUID);
  // log("Constants.userUid is ${preferences.getString(userUID)}");
  // DataOfUser _dataOfUser=DataOfUser();
  // UserInFireBase _userInFireBase=UserInFireBase();
  DataOfUser.idOfUserInAppUser=preferences.getString(userUID)??'';

  // _dataOfUser.getDataOfUser().then((v){
  //   log("v['name']is ${v['name']}");
    DataOfUser.nameInAppUser=preferences.getString(userName)??'';
    log("DataOfUser.nameInAppUser is ${DataOfUser.nameInAppUser}");
    DataOfUser.emailInAppUser=preferences.getString(userEmail)??'';
  // });
// }
  if(preferences.getBool(login)==null) {
    log("((((((((((())))))))))))");

    saveMainColor(colorMain).then((v){
      log("color of main is ${preferences.getInt(mainColor)}");
      Constants.mainColor=preferences.getInt(mainColor);
    });
    saveListOfZekr(listOfZekr: [
      'سبحان الله و بحمده - 33',
      'لا حول ولا قوة إلا بالله - 33',
      'اللهم صل علي سيدنا محمد و علي اله و صحبه و سلم - 100',
      'أستغفر الله العظيم - 1000'
    ]);
  }
    Constants.mainColor=preferences.getInt(mainColor)==null?colorMain:preferences.getInt(mainColor);
  log("preferences.getInt(mainColor) is ${preferences.getInt(mainColor)}");
  Constants.colorThemes=preferences.getBool(colorTheme)==null||
      preferences.getBool(colorTheme)==false?false:true;
  Constants.lat=preferences.getDouble(lat);
  Constants.long=preferences.getDouble(long);
  Constants.timeZone=preferences.getDouble(timeZone);

  runApp( MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=> ChangeTime()),
        ChangeNotifierProvider(create: (context)=> ThemeProvider()),
        ChangeNotifierProvider(create: (context)=> ProviderBookMark()),
      ],
      builder: (context,_){
        final themeProvider = Provider.of<ThemeProvider>(context);

        themeProvider.toggleTheme(Constants.colorThemes);
        return MaterialApp(
          themeMode: themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          debugShowCheckedModeBanner: false,
          title: "Al-Wahab",
          // home: Test(),
          home: HomePage(),
        );
      },
    );
  }
}

//CN=Alaa, OU=test, O=test, L=test, ST=test, C=mn correct?