
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget widgetText({String text,Color color:Colors.black,FontWeight fontWeight:FontWeight.normal,
  double fontSize,TextAlign textAlign:TextAlign.start,TextDirection textDirection:TextDirection.rtl
}){
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      color: color,fontWeight:fontWeight
    ),
    textDirection: textDirection,
    textAlign: textAlign,
  );
}