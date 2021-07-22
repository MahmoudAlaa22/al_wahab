import 'dart:developer';

import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/provider_book_mark.dart';
import 'package:al_wahab/controller/shared_preferences.dart';
import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/model/quran.dart';
import 'package:al_wahab/widgets/style_widget.dart';
import 'package:al_wahab/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuranInJuz extends StatefulWidget {
  List<Surah> surahList;
  int numberOfJuz;
  double offset;
  String id;
  QuranInJuz({@required this.id,@required this.surahList,@required this.numberOfJuz,this.offset:0.0});
  @override
  _QuranInJuzState createState() => _QuranInJuzState();
}

class _QuranInJuzState extends State<QuranInJuz> {
List listOfAyah=[];
List<Surah>listOfSurah=[];
String ayahs;
bool check;
ThemeProvider themeProvider;
ScrollController controller ;
double offsetPos=0.0;
ProviderBookMark providerBookMark;
void getJuz(){
  for(int i=0;i<widget.surahList.length;i++){
    ayahs='';
    check=false;
    for(int j=0;j<widget.surahList[i].ayahs.length;j++){
      if(widget.surahList[i].ayahs[j].juz==widget.numberOfJuz){
        setState(() {
          check=true;
          log("${widget.surahList[i].ayahs[j].text.contains(basmala)}");
          // ayahs+=widget.surahList[i].ayahs[j].text+"﴿${j + 1}﴾";
          ayahs+="${( widget.surahList[i].ayahs[j].text.contains(basmala) &&
              widget.surahList[i].number != 1) ? "${widget.surahList[i].ayahs[j].text.substring(basmala.length)} ﴿${j + 1}﴾ "
              : "${widget.surahList[i].ayahs[j].text} ﴿${j + 1}﴾"} ";
        });
      }
    }
    //المفروض هظبط السور
    if(check){
      listOfSurah.add(widget.surahList[i]);
      listOfAyah.add(ayahs);
    }
  }
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("widget.offset is ${widget.offset}");
    controller=ScrollController(initialScrollOffset: widget.offset);
    // controller.animateTo(1735, duration: Duration(seconds: 1), curve: Curves.easeIn);
    getJuz();
    controller.addListener(() {
      setState(() {
        offsetPos=controller.offset;
      });
      // log("_controller offset ${controller.offset}  position ${controller.position}");
    });
  }

@override
  void didChangeDependencies() {
  themeProvider = Provider.of<ThemeProvider>(context);
  providerBookMark = Provider.of<ProviderBookMark>(context);
  super.didChangeDependencies();
}

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    providerBookMark.changeBookMark(juz: widget.numberOfJuz,
        offset: offsetPos==null||offsetPos==0.0?
    providerBookMark.bookMarkOfOffset:offsetPos);
    addBookMark(
      id: widget.id ,
      juz: widget.numberOfJuz,
      offset: offsetPos==null||offsetPos==0.0?
      providerBookMark.bookMarkOfOffset:offsetPos
    ).then((v){
      Constants.bookMarkOfOffset=offsetPos;
      Constants.bookMarkOfJuz=widget.numberOfJuz;
      log("GGGGGGGGGGGG");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context,text: 'القرآن الكريم'),
      body: Stack(
        children: [
          ListView.separated(
            controller: controller,
            padding: EdgeInsets.only(bottom: getScreenOfHeight*0.07as double),
            itemBuilder: (_,i){
            if(listOfSurah.isEmpty)return const CircularProgressIndicator();
            return Column(
              children: [
                widgetText(text: listOfSurah[i].name,color:Color(Constants.mainColor),
                    fontSize: getScreenOfWidth*0.075 as double,fontWeight:FontWeight.w500  ),
              if (listOfSurah[i].number!=1&&listOfSurah[i].number!=9) widgetText(text: basmala,color: themeProvider.isDarkMode
                  ? Constants.sceColor:Colors.grey.shade900,
                  fontSize: getScreenOfWidth*0.065as double,fontWeight:FontWeight.w700
              ) else Row(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: widgetText(text: listOfAyah[i]as String,color: themeProvider.isDarkMode
                      ? Constants.sceColor:Colors.grey.shade900,
                    fontSize: getScreenOfWidth*0.055as double
                  ),
                ),
              ],
            );
          }, separatorBuilder: (_,i){
            return  Divider(
              color: Color(Constants.mainColor),
              height: 2.0,
            );
          }, itemCount: listOfSurah.length),

          Positioned(
            bottom: 0,
              child: Container(
                width: getScreenOfWidth as double,
                height: getScreenOfHeight*0.08as double,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              color: themeProvider.isDarkMode?Colors.black:Colors.white,
boxShadow: [BoxShadow(color:Color(Constants.mainColor),blurRadius: 5 )]
            ),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceAround,
              children: [
                TextButton(onPressed: (){},
                    child: widgetText(text: 'تم القراءة',color: Color(Constants.mainColor),
                        fontSize: getScreenOfWidth*0.05as double
                    )),
                TextButton(onPressed: (){}, child: widgetText(text: 'الغاء',color: Colors.red,
                    fontSize: getScreenOfWidth*0.05 as double),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
