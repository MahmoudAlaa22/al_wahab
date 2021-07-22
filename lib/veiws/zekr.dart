import 'dart:developer';

import 'package:al_wahab/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/model/azkar.dart';
import 'package:al_wahab/widgets/style_widget.dart';

class Zekr extends StatefulWidget {
  String category;
  List<Azkar> azkar;

  Zekr({@required this.category, this.azkar});

  @override
  _ZekrState createState() => _ZekrState();
}

class _ZekrState extends State<Zekr> {
  List<Azkar> _azkar = [];
  List<Map>listOfZaker=[];
  Color _color=Color(Constants.mainColor);
  chickAzkar() {
    widget.azkar.forEach((element) {
      if (widget.category == element.category) {
        log("element.count is ${element.count==""} ***");
        _azkar.add(element);
       listOfZaker.add({
         'count':element.count==""?1:int.parse(element.count as String),
         'state':false,
         'color':_color,
       });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    chickAzkar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context: context,text: widget.category),
        body: ListView.builder(
          itemCount: _azkar.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(offset: Offset(2, 4), blurRadius: 5)
                      ]),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.end ,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            widgetText(text: _azkar[i].zekr as String,fontSize: 20),
                            SizedBox(height: getScreenOfHeight*0.01as double,),
                            widgetText(text: _azkar[i].description as String,color: Color(Constants.mainColor)),
                          ],
                        ),
                      ),
                      SizedBox(height: getScreenOfHeight*0.01as double,),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            listOfZaker[i]['state']=!(listOfZaker[i]['state'] as bool);
                            listOfZaker[i]['count'] ==0?
                              listOfZaker[i]['count'] = 0
                            : listOfZaker[i]['count']--;
                            if(listOfZaker[i]['count'] ==0)listOfZaker[i]['color'] = Colors.red;
                            log("count is ${listOfZaker[i]['count']}");
                          });
                        },
                        child: AnimatedContainer(
                          onEnd: (){
                            setState(() {
                              listOfZaker[i]['state']=false;
                            });
                            log(":::::::::::::::::::::");
                          },
                          duration: Duration(milliseconds:100 ),
                          curve: Curves.linear,
                          alignment: Alignment.center,
                          height: listOfZaker[i]['state']as bool?50:80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            color: listOfZaker[i]['color'] as Color,
                          ),
                          child: Center(child: widgetText(
                              text: "${listOfZaker[i]['count']}",
                              fontSize: 20,
                            color: Colors.white
                          )),
                        ),
                      ),
                    ],
                  )),
            );
          },
        ));
  }
}
