import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/provider.dart';
import 'package:al_wahab/controller/shared_preferences.dart';
import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/veiws/rosary.dart';
import 'package:al_wahab/widgets/style_widget.dart';
import 'package:al_wahab/widgets/widgets.dart';

import 'add_zekr.dart';

class ElectronicRosary extends StatefulWidget {
  @override
  _ElectronicRosaryState createState() => _ElectronicRosaryState();
}

class _ElectronicRosaryState extends State<ElectronicRosary> {

  List<String> settingOfZekr = ['تعديل ✍', 'حذف ❌'];
  ChangeTime changeTime;
  List<String>listOfAzkar=[];
  ThemeProvider themeProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    changeTime = Provider.of(context);
    themeProvider=Provider.of(context);
  }

  Widget boxListTitle({String text1,String text2,int index}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            CupertinoPageRoute(builder: (_)=>Rosary(
              zekr: text1,countOfZekr: int.parse(text2),
            ))
          );
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: themeProvider.showDark?Colors.black:Constants.sceColor,
              boxShadow: [styleOfBoxShadow(blurRadius: 5)],
              borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton(
                icon: Icon(Icons.adaptive.more,color: Color(Constants.mainColor),),
                onSelected: (v) {
                  if(v==settingOfZekr[0]){
                    log("88888888");
                    showDialog(context: context, builder: (_){
                      return AddZekr(
                        zekr: text1,
                        countOfZekr: text2,
                        index: index,
                      );
                    });
                  }
                  else{
                    changeTime.getDeleteListOfAzkar(index);
                    log("changeTime.listOfAzkar is ${changeTime.listOfAzkar}");
                    saveListOfZekr(
                      listOfZekr:changeTime.listOfAzkar
                    );
                  }
                },
                itemBuilder: (context) {
                  return settingOfZekr.map((setting) {
                    return PopupMenuItem(
                      value: setting,
                      child: Text(setting),
                    );
                  }).toList();
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  widgetText(text: text1,color: themeProvider.showDark?Color(Constants.mainColor):Colors.black),
                  widgetText(text: text2,color: themeProvider.showDark?Color(Constants.mainColor):Colors.black),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getListOfAzkar();
  }

  getListOfAzkar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      changeTime.getListOfAzkar(list: prefs.getStringList(keyListOfZekr));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(Constants.mainColor),
        child: Icon(Icons.add,color: themeProvider.showDark?Colors.black:Colors.white,),
        onPressed: () {
          showDialog(context: context, builder: (context) => AddZekr());
        },
      ),
      appBar:appBar(text: "المسبحة الالكترونية",context: context),
      body: ListView.builder(
        itemCount: changeTime.listOfAzkar.length,
        itemBuilder: (context, i) {
          List list = changeTime.listOfAzkar[i].split('-');
          return boxListTitle(text1: list[0]as String , text2: list[1]as String ,index: i);
        },
      ),
    );
  }
}
