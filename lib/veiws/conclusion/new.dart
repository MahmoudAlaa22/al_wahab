import 'dart:developer';

import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/firebase/store.dart';
import 'package:al_wahab/widgets/animation_page.dart';
import 'package:al_wahab/widgets/style_widget.dart';
import 'package:al_wahab/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'juz.dart';

class New extends StatefulWidget {

  @override
  _NewState createState() => _NewState();
}

class _NewState extends State<New> {
  List title = [
    'ختمة قرآن سنوية',
    'ختمة قرآن أربعينية',
    'ختمة قرآن إهداء للإمام',
    'ختمة قرآن إهداء لأرواح المؤمنين والمؤمنات',
    'ختمة قرآن لشفاء',
    'ختمة قرآن لقضاء حاجة وتيسير الأمور',
    'اخري'
  ];
  List divideQ = ['اجزاء'];
  String valueChose = "ختمة قرآن سنوية";
  String valueOfDivideQ = "اجزاء",name='';
  Store _store=Store();
  double height = getScreenOfHeight * 0.06 as double,
      width = getScreenOfWidth as double,
      fon = 25.0;
  final formKey = GlobalKey<FormState>();


  createConclusion({@required BuildContext context})async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      await _store.addNewConclusion(
        name: name,title: valueChose,wayToDivide: valueOfDivideQ,
        readers: [],
      ).then((v){
        log("v kkk is $v");
        Future.delayed(const Duration(milliseconds: 160), () {
          Navigator.of(context).push(CupertinoPageRoute(builder: (_) => Juz(
            id: v.id as String ,
          )));
        });
      });

    }
  }

  Widget columnWidget({Widget child, String text}) {
    return Padding(
        padding: EdgeInsets.all(getScreenOfHeight * 0.01 as double),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widgetText(
                text: text, color: Color(Constants.mainColor), fontSize: 18.0),
            child,
          ],
        ));
  }

  Widget dropdownButton({valueOfDrop, ValueChanged onChanged, List items}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getScreenOfWidth * 0.03as double,
          vertical: getScreenOfHeight * 0.005as double),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(Constants.mainColor)),
      ),
      child: dropdownButtonWidget(
        valueOfDrop: valueOfDrop,onChanged: onChanged,items: items
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, text: 'ختمة جديدة'),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(getScreenOfHeight * 0.02 as double),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                columnWidget(
                    text: 'عنوان الختمة',
                    child: dropdownButton(
                        items: title,
                        onChanged: (v) {
                          setState(() {
                            valueChose = v as String;
                          });
                        },
                        valueOfDrop: valueChose)),
                columnWidget(
                  text: 'إسم المقصود بالختمة و الصفة',
                  child: textFormField(
                      labelText: "الإمام... /المرحوم... /على روح... /المريض",
                      autofocus: false,
                      onChanged: (String v) {
                        name=v;
                      },
                      validator: (String v) {
                        if (v.isEmpty) {
                          return Constants.massageOfValidator;
                        }
                      }),
                ),
                columnWidget(
                    text: 'طريقة تقسيم القرآن الكريم',
                    child: dropdownButton(
                        items: divideQ,
                        onChanged: (v) {
                          setState(() {
                            valueOfDivideQ = v as String;
                          });
                        },
                        valueOfDrop: valueOfDivideQ)),
                SizedBox(
                  height: getScreenOfHeight * 0.05 as double,
                ),
                Center(
                  child: animationButton(
                    color: Color(Constants.mainColor),
                      milliseconds: 122,
                      child: Center(
                          child: widgetText(text: "انشاء", fontSize: fon)),
                      shape: BoxShape.rectangle,
                      height: height,
                      width: width,
                      onTap: () {
                        setState(() {
                          width = getScreenOfWidth * 0.6as double;
                          height = height = getScreenOfHeight * 0.05as double;
                          fon = 20.0;
                        });
                        createConclusion(context: context);
                      },
                      onEnd: () {
                        setState(() {
                          width = getScreenOfWidth as double;
                          height = height = getScreenOfHeight * 0.06as double;
                        });
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
