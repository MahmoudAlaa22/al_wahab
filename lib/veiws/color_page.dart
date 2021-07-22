import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/shared_preferences.dart';
import 'package:al_wahab/main.dart';
import 'package:al_wahab/widgets/style_widget.dart';
import 'package:al_wahab/widgets/widgets.dart';

import 'home.dart';

class ColorPage extends StatefulWidget {
  @override
  _ColorPageState createState() => _ColorPageState();
}

class _ColorPageState extends State<ColorPage> {
  Color _customColor = Colors.green;

  changeColor(){
  String colorToString=_customColor.toString();
  int color;
  if(colorToString.contains("Material")) color=int.parse(colorToString.substring(35,45));
  else  color=int.parse(colorToString.substring(6,16));
 log("Color in method is ${Color(color)}");
  saveMainColor(color);
  Constants.mainColor=color;
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (_)=>MyApp()
  ));
}
  @override
  Widget build(BuildContext context) {
    log("_customColor is ${_customColor.toString()}");
    return Scaffold(
      appBar:appBar(text: 'Colors',context: context,
      actions: [
        TextButton(onPressed: (){
          changeColor();
        }, child: widgetText(text: 'SAVE',color: Color(Constants.mainColor)))
      ]
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: 350,
                height: 150,
                child: Center(
                  child: Text('Main color is: '),
                ),
                decoration: new BoxDecoration(color: _customColor),
              ),
              ColorPicker(
                color: _customColor,
                onChanged: (value) {
                  setState(() {
                    _customColor = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
