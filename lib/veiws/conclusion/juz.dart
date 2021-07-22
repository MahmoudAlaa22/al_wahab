import 'dart:async';
import 'dart:developer';

import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/provider_book_mark.dart';
import 'package:al_wahab/controller/quran_api.dart';
import 'package:al_wahab/controller/shared_preferences.dart';
import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/firebase/store.dart';
import 'package:al_wahab/model/quran.dart';
import 'package:al_wahab/model/user.dart';
import 'package:al_wahab/veiws/conclusion/quran_in_juz.dart';
import 'package:al_wahab/veiws/login_signin/login_and_signup.dart';
import 'package:al_wahab/widgets/animation_page.dart';
import 'package:al_wahab/widgets/loading_shimmer.dart';
import 'package:al_wahab/widgets/scale_transition.dart';
import 'package:al_wahab/widgets/style_widget.dart';
import 'package:al_wahab/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Juz extends StatefulWidget {
  final String id;

  Juz({this.id});

  @override
  _JuzState createState() => _JuzState();
}

class _JuzState extends State<Juz> {
  ThemeProvider themeProvider;
 final DataOfUser _dataOfUser = DataOfUser();
  List readers = [];
  List willReading=[];
  bool check = false;
  final Store _store = Store();
  List<Surah> surahList = [];
  ProviderBookMark providerBookMark;
  final _panelController = PanelController();
int indexOfReaders;
  void yesButton() {
    if(DataOfUser.idOfUserInAppUser!=null && DataOfUser.nameInAppUser.isNotEmpty) {
      readers.add({
        Readers.name: DataOfUser.nameInAppUser,
        Readers.id: DataOfUser.idOfUserInAppUser,
        Readers.email: DataOfUser.emailInAppUser,
        Readers.willReading: willReading,
      });
      log("asdasdsfsf");
      updateReader(text: "تم اضافة هذه الختمه");
    }
    else{
      showDialogWidget(
        text: 'يجب تسجيل الدخول اولا اضغط نعم لتسجيل الدخول',
        no: (){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        yes: (){
          Navigator.of(context).push(
              CupertinoPageRoute(builder: (_)=>LoginAndSignUpScreen())
          );
        }
      );
    }
  }
  void updateReader({@required String text}){
    _store.addNewReader(
        docId: widget.id, reader: readers).then((v) {
      setState(() {
        check = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration:const Duration(milliseconds: 500),
        backgroundColor: Color(Constants.mainColor),
        content: widgetText(text: text ,color: Colors.white),
      ));
      Navigator.of(context).pop();
    });
  }
void yesButton2({int juz}){
    //اخد الرقم و اعمل اتشيك عليه عشان اعرف هل انا مسجل فيه ولا
  willReading.add(juz);
  readers[indexOfReaders][Readers.willReading]=willReading;
  updateReader(text: "تم اضافة هذا الجزء");
  log("willReading is ${readers[indexOfReaders][Readers.willReading]}");
}
  void showDialogWidget({String text,VoidCallback yes,VoidCallback no}) {
    showDialog(
        //بتمنع انها تختفي لما ادوس ف اي مكان ف الشاشه
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return WidgetOfScaleTransition(
              child: Container(
            width: getScreenOfWidth * 0.5 as double,
            height: getScreenOfHeight * 0.2 as double,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Color(Constants.mainColor), width: 2),
                color: themeProvider.isDarkMode
                    ? Colors.grey.shade900
                    : Constants.sceColor,
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widgetText(
                    text: text,
                    color: Color(Constants.mainColor)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: yes,
                        child: widgetText(
                            text: 'نعم', color: Color(Constants.mainColor))),
                    TextButton(
                        onPressed: no,
                        child: widgetText(
                            text: 'لا', color: Color(Constants.mainColor))),
                  ],
                )
              ],
            ),
          ));
        });
  }

  Widget cont({@required int i}) {
    log("checkOfIsReading is ${willReading.contains(i)}");
    return GestureDetector(
      onTap: () {
        if (willReading.isEmpty||!willReading.contains(i)) {
          showDialogWidget(text:"هل تريد قراءة هذا الجزء " ,
          yes:(){
            yesButton2(juz: i);
          },
            no: () {
              Navigator.of(context).pop();
            }
          );
        } else {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (_) => QuranInJuz(
                id: widget.id,
                    numberOfJuz: i,
                    surahList: surahList,
                  )));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(Constants.mainColor),width: 1.5),
          color:willReading.contains(i)?Color(Constants.mainColor):
          themeProvider.isDarkMode?
          Colors.grey.shade900:Colors.white,
          boxShadow: [styleOfBoxShadow(blurRadius: 3)]
        ),
        child: Center(
            child: widgetText(
                text: '$i', fontSize: 35, color:willReading.contains(i)?Colors.white: Color(Constants.mainColor))),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataOfUser.checkIfUserInIt(docId: widget.id).then((v) {
      setState(() {
        readers = v[Conclusion.readers] as List;
        for (int i = 0; i < readers.length; i++) {
          check = readers[i][Readers.id].contains(DataOfUser.idOfUserInAppUser) as bool;
          if(check) {
            willReading=readers[i][Readers.willReading]as List;
            indexOfReaders=i;
            break;
          }
        }
        checkFun();
      });
    });
if(DataOfUser.idOfUserInAppUser.isEmpty) {
      Future.delayed(Duration.zero, () {
        checkFun();
      });
    }
    getBookMark(id: widget.id).then((value) {
      providerBookMark.changeBookMark(offset:Constants.bookMarkOfOffset ,juz:Constants.bookMarkOfJuz );
      // listOfCont();
    });
  }
  void checkFun(){
    if (!check || check == null) {
      showDialogWidget(
          text: 'هل تريد اضافه هذه الختمه الي مجموعتك',
          yes: yesButton,
          no: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
      );
    }
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
    log("dispose<<<<>>>>>>");
    // _panelController.close().then((value) => log("<<>>><<HGHG>><<>>"));
  }

  Widget buttonInSlidingUpPanel({String text,Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: themeProvider.isDarkMode ? Colors.black : Colors.white,
            boxShadow: const[
              BoxShadow(blurRadius: 5, spreadRadius: 1, offset: Offset(2, 3)),
            ]),
        width: getScreenOfWidth * 0.2 as double,
        height: getScreenOfHeight * 0.05 as double,
        child: widgetText(
            text: text,
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
            textAlign: TextAlign.center,
            fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, text: "الاجزاء",
      //     actions: [
      //   IconButton(icon: Icon(Icons.error_outline,size: 30,color: Color(Constants.mainColor),),
      //   onPressed: (){
      //     showModalBottomSheet(context: context, builder: (_){
      //       return Container(
      //         width: getScreenOfWidth as double,
      //         height: getScreenOfHeight/2 as double,
      //         child: Row(),
      //       ) ;
      //     });
      //   },
      //   )
      // ]
      ),
      body: SlidingUpPanel(
        color: Color(Constants.mainColor),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        minHeight: providerBookMark.bookMarkOfOffset == null
            ? 0
            : getScreenOfHeight * 0.06 as double,
        maxHeight: getScreenOfHeight * 0.2 as double,
        backdropEnabled: true,
        backdropOpacity: 0.5,
        // onPanelOpened: () {
        //   Timer.periodic(Duration(seconds: 5), (timer) {
        //     _panelController.close();
        //   });
        // },
        controller: _panelController,
        body: FutureBuilder(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/json/quran.json'),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return LoadingShimmer(
                  text: "الاجزاء",
                );
              }
              surahList = QuranApi.parseJson(snapshot.data.toString());
              return Padding(
                padding: EdgeInsets.all(getScreenOfWidth * 0.02 as double),
                child: GridView.count(
                  mainAxisSpacing: getScreenOfWidth * 0.03 as double,
                  crossAxisSpacing: getScreenOfWidth * 0.03 as double,
                  crossAxisCount: 5,
                  children: List.generate(30, (index) => cont(i: index+1)),
                ),
              );
            }),
        panel: Column(
          children: [
            widgetText(
                text: 'هل تريد المتابعة من حيث توقفت؟',
                color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                fontSize: getScreenOfWidth * 0.05 as double,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w700),
            SizedBox(
              height: getScreenOfHeight * 0.04 as double,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buttonInSlidingUpPanel(
                    onTap: () async{
                      _panelController.close();
                     var nav= await Navigator.of(context).push(CupertinoPageRoute(
                          builder: (_) => QuranInJuz(
                            id: widget.id,
                                numberOfJuz: providerBookMark.bookMarkOfJuz,
                                offset: providerBookMark.bookMarkOfOffset,
                                surahList: surahList,
                              )));
                     log("v is Navigator the value is ${nav}");
                     if(nav==true||nav==null){
                       getBookMark(id: widget.id).then((value) {
                         providerBookMark.changeBookMark(offset:Constants.bookMarkOfOffset ,juz:Constants.bookMarkOfJuz );
                       });
                     }
                    },
                    text: 'متباعة'),
                buttonInSlidingUpPanel(
                    onTap: () {
                      _panelController.animatePanelToPosition(0.0);
                    },
                    text: 'اخفاء'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
