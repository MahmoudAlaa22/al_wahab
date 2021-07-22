import 'dart:developer';

import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/widgets/scale_transition.dart';
import 'package:al_wahab/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/provider.dart';
import 'package:al_wahab/controller/shared_preferences.dart';
import 'package:al_wahab/widgets/style_widget.dart';

class AddZekr extends StatefulWidget {
  String zekr,countOfZekr;
  int index;
  AddZekr({this.index,this.countOfZekr,this.zekr});

  @override
  _AddZekrState createState() => _AddZekrState();
}

class _AddZekrState extends State<AddZekr> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation<double> scaleAnimation;
  String nameOfZekr='',countOfZekr='';
  final form=GlobalKey<FormState>();
  List<String>listOfZekr=[];
  ChangeTime changeTime;
  ThemeProvider themeProvider;

  @override
  void didChangeDependencies() {
    changeTime=Provider.of<ChangeTime>(context);
    themeProvider = Provider.of(context);

    super.didChangeDependencies();
  }
  @override
  void initState() {
    super.initState();

    getListOfZekr();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }
  Future<void> addZekr()async{
    final formData=form.currentState;
    if(formData.validate()){
      formData.save();
      log("$nameOfZekr -----------> $countOfZekr" );
      listOfZekr.add("$nameOfZekr - $countOfZekr");
      saveListOfZekr(
        listOfZekr:listOfZekr
      );
      Navigator.of(context).pop();
    }
  }
 Future<void> editZekr()async{
    final formData=form.currentState;
    if(formData.validate()){
      formData.save();
      setState(() {
        nameOfZekr=nameOfZekr.isEmpty?widget.zekr:nameOfZekr;
        countOfZekr=countOfZekr.isEmpty?widget.countOfZekr:countOfZekr;
      });
      listOfZekr[widget.index]="$nameOfZekr - $countOfZekr";
      log("listOfZekr[widget.index] is ${listOfZekr[widget.index]}");
      saveListOfZekr(
          listOfZekr:listOfZekr
      );
      Navigator.of(context).pop();
    }
  }
 Future<void> getListOfZekr()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      setState(() {
        changeTime.getListOfAzkar(list:prefs.getStringList(keyListOfZekr));
        listOfZekr=changeTime.listOfAzkar;
      });
    }
    catch(e){
      log("There is Error in SharedPreferences is $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    log("Constants.listOfZekr is ${Constants.listOfZekr}");
    return WidgetOfScaleTransition(
      child:Container(
        padding:const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(color: Color(Constants.mainColor),width: 2),
            color: themeProvider.isDarkMode?Colors.grey.shade900:Constants.sceColor,
            borderRadius: BorderRadius.circular(15)
        ),
        width: getScreenOfWidth*0.9 as double,
        child: SingleChildScrollView(
          child: Form(
            key: form,
            child: Column(
              children: [
                widgetText(text: "اضف ذكر للمسبحة",fontSize: 25,color: Color(Constants.mainColor) ),
                textFormField(
                  initialValue:widget.zekr ?? '',
                  labelText: "الذكر",
                  autofocus: false,keyboardType: TextInputType.text,
                  onChanged: (String v){
                    setState(() {
                      nameOfZekr=v;
                    });
                  },
                  validator: (String v){
                    if(v.isEmpty)return "هذا الحقل فارغ";
                  },
                ),
                SizedBox(height: getScreenOfHeight*0.02as double,),
                textFormField(
                  initialValue:widget.countOfZekr ?? '',
                  labelText: "عدد الحبات",
                  autofocus: false,keyboardType: TextInputType.number,
                  onChanged: (String v){
                    setState(() {
                      countOfZekr=v;
                    });
                  },
                  validator: (String v){
                    if(v.isEmpty) {
                      return "هذا الحقل فارغ";
                    }
                  },
                ),
                SizedBox(height: getScreenOfHeight*0.005as double,),
                Row(
                  mainAxisAlignment:MainAxisAlignment.end ,
                  children: [
                    TextButton(onPressed: (){Navigator.of(context).pop();}, child: widgetText(text: 'الغاء',color: Color(Constants.mainColor),fontWeight: FontWeight.bold)),
                    if (widget.index==null) TextButton(onPressed: (){
                      addZekr().then((v){
                        getListOfZekr();
                      });
                    }, child:
                    widgetText(text: 'اضافة',color: Color(Constants.mainColor),fontWeight: FontWeight.bold))
                    else TextButton(
                        onPressed: (){
                          editZekr().then((v){
                            getListOfZekr();
                          });
                        }, child:
                    widgetText(text: 'تعديل',color: Color(Constants.mainColor),fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
        ),
      ) );
  }
}
