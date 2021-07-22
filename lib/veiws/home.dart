import 'dart:async';
import 'dart:developer';

import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/location.dart';
import 'package:al_wahab/controller/prayer_time.dart';
import 'package:al_wahab/controller/provider.dart';
import 'package:al_wahab/controller/quran_api.dart';
import 'package:al_wahab/controller/shared_preferences.dart';
import 'package:al_wahab/model/pray.dart';
import 'package:al_wahab/model/quran.dart';
import 'package:al_wahab/veiws/quran/al_quran_al_karim.dart';
import 'package:al_wahab/widgets/drawer.dart';
import 'package:al_wahab/widgets/prayer_time_list.dart';
import 'package:al_wahab/widgets/style_widget.dart';
import 'package:al_wahab/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'azkar_page.dart';
import 'conclusion/conclusion_page.dart';
import 'conclusion/new.dart';
import 'electronic_rosary.dart';
import 'list_of_radios_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  List quranImages = [];
  List<Tafaseer> tafaseerList = [];
  QuranApi _quranApi = QuranApi();
  Location location = new Location();
  List<String> _prayerTimes = [];
  List<String> _prayerNames = [];
  TimeOfDay isha;
  TimeOfDay formattedDate = TimeOfDay.fromDateTime(DateTime.now());
  ChangeTime changeTime;
  List<Map> prayTimes = [];
  int _hr, _minute;
  var now = DateTime.now();
  DateTime timeOfCurrentlyPray;

  getPrayerTimes() async {
    PrayerTime prayers = PrayerTime();

    prayers.setTimeFormat(prayers.getTime24());
    prayers.setCalcMethod(prayers.getEgypt());
    prayers.setAsrJuristic(prayers.getShafii());
    prayers.setAdjustHighLats(prayers.getAdjustHighLats());

    List<int> offsets = [
      0,
      0,
      0,
      0,
      0,
      0,
      0
    ]; // {Fajr,Sunrise,Dhuhr,Asr,Sunset,Maghrib,isha}
    prayers.tune(offsets);

    var currentTime = DateTime.now();

    // setState(() {
    // for (int i = 0; i < 7; i++) {
    //   listPrayerTimes.add(prayers.getDatePrayerTimes(
    //       currentTime.year,
    //       currentTime.month,
    //       currentTime.day + i,
    //       Constants.lat,
    //       Constants.long,
    //       Constants.timeZone));
    // }

    if (Constants.long != null && Constants.lat != null) {
      _prayerTimes = prayers.getPrayerTimes(
          currentTime, Constants.lat, Constants.long, Constants.timeZone);
      _prayerNames = prayers.getTimeNames();
    }
    // });
  }

  getDifferDifferenceBetweenTime({yourTime, timeOfNow}) {
    double _doubleYourTime =
        yourTime.hour.toDouble() + (yourTime.minute.toDouble() / 60)as double;
    double _doubleNowTime =
        timeOfNow.hour.toDouble() + (timeOfNow.minute.toDouble() / 60)as double;
    double _timeDiff = _doubleYourTime - _doubleNowTime;
    _hr = _timeDiff.truncateToDouble().toInt();
    _minute = ((_timeDiff - _timeDiff.truncate()) * 60).round();
    log('Here your Happy $_hr Hour and also $_minute min');
  }

  howToCalculateChangeInPray() async {
    if (_prayerTimes.isNotEmpty) {
      isha = TimeOfDay(
          hour: int.parse(_prayerTimes[_prayerTimes.length - 1].split(":")[0]),
          minute:
              int.parse(_prayerTimes[_prayerTimes.length - 1].split(":")[1]));

      for (int i = 0; i < 7; i++) {
        TimeOfDay _startTime = TimeOfDay(
            hour: int.parse(_prayerTimes[i].split(":")[0]),
            minute: int.parse(_prayerTimes[i].split(":")[1]));
        if (i != 1 && i != 4) {
          if ((DateTime.now().hour >= isha.hour &&
                  DateTime.now().minute >= isha.minute) ||
              DateTime.now().hour > isha.hour) {
            var asd = "24:00";
            var g = TimeOfDay(
                hour: int.parse(asd.split(":")[0]),
                minute: int.parse(asd.split(":")[1]));
            log("in else if Error");
            getDifferDifferenceBetweenTime(
                yourTime: g, timeOfNow: DateTime.now());
            setState(() {
              timeOfCurrentlyPray= null;
            });
            prayTimes.add({
              Pray.hour: _hr,
              Pray.minute: _minute,
              Pray.nameInEn: "midnight",
              Pray.nameInAr: "منتصف الليل",
            });
            log("prayTimes is ${prayTimes}");
            changeTime.stringTimeChange(
                "${prayTimes[0][Pray.hour].toString().padLeft(2, "0")}:${prayTimes[0][Pray.minute].toString().padLeft(2, "0")}");
            break;
          } else if (DateTime.now().hour <= _startTime.hour) {
            getDifferDifferenceBetweenTime(
                yourTime: _startTime, timeOfNow: DateTime.now());
            setState(() {
              timeOfCurrentlyPray = DateTime(now.year, now.month, now.day,
                  _startTime.hour, _startTime.minute);
            });
            if (_minute.toInt() == 60) {
              _hr++;
              _minute = 0;
            }
            if (_minute.toInt() <= 0 && _hr.toInt() == 0) {
              log("continue");
              continue;
            } else {
              prayTimes.add({
                Pray.hour: _hr,
                Pray.minute: _minute,
                Pray.nameInEn: _prayerNames[i],
                Pray.nameInAr: Constants.nameOfPrayLise[i],
              });
              log("prayTimes is ${prayTimes}");
              changeTime.stringTimeChange(
                  "${prayTimes[0][Pray.hour].toString().padLeft(2, "0")}:${prayTimes[0][Pray.minute].toString().padLeft(2, "0")}");
              // if(i>4) {
              //   var width=_scrollController.position.maxScrollExtent;
              //   _scrollController.jumpTo(width);
              //   }
              break;
            }
          }
        }
      }
    }
  }

  _timeOfTimer() {
    log("IIIIIIIIIIIII");
    if (prayTimes.isNotEmpty) {
      setState(() {
        log("11111111111");
        if (prayTimes[0][Pray.minute] == 0 && prayTimes[0][Pray.hour] > 0 as bool) {
          prayTimes[0][Pray.hour]--;
          prayTimes[0][Pray.minute] = 59;
        } else {
          log("33333333333333");
          log(
              "^^^^ ${prayTimes[0][Pray.hour].toString().padLeft(2, "0")}:${prayTimes[0][Pray.minute].toString().padLeft(2, "0")}");
          prayTimes[0][Pray.minute]--;
          log("prayTimes[0][Pray.minute]-- is ${prayTimes[0][Pray.minute]}");
          if (prayTimes[0][Pray.minute] <= 0 as bool  && prayTimes[0][Pray.hour] == 0) {
            prayTimes.clear();
            howToCalculateChangeInPray();
          }
        }
        changeTime.timeString =
            "${prayTimes[0][Pray.hour].toString().padLeft(2, "0")}:${prayTimes[0][Pray.minute].toString().padLeft(2, "0")}";
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrayerTimes().then((v) {
      howToCalculateChangeInPray();
    });
    saveLogIn(logn: true);
    if (Constants.long == null && Constants.lat == null) {
      getPermissionOfLocation().then((v) {
        getLocationOnLocationChanged();
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
      });
    }
    DefaultAssetBundle.of(context)
        .loadString('assets/json/ar_muyassar.json')
        .then((value) {
      setState(() {
        tafaseerList = _quranApi.tafaseerParseJson(value);
      });
    });
    Timer.periodic(Duration(seconds: 60 - DateTime.now().second), (Timer t) {
      log("PPPPPPPPPPPPPPPP");
      _timeOfTimer();
      t.cancel();
      Timer.periodic(Duration(seconds: 60), (Timer t) {
        _timeOfTimer();
      });
    });

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    changeTime = Provider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    setScreenOfHeight(size.height);
    setScreenOfWidth(size.width);
    final keyScaffold = GlobalKey<ScaffoldState>();
    return Scaffold(
      endDrawerEnableOpenDragGesture: false,
      drawer: widgetDrawer(context: context),
      key: keyScaffold,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.47,
            floating: true,
            pinned: true,
            title:
                widgetText(text: 'Al-Wahab', color: Color(Constants.mainColor)),
            leading: InkWell(
                onTap: () {
                  keyScaffold.currentState.openDrawer();
                },
                child: Icon(
                  Icons.menu,
                  color: Color(Constants.mainColor),
                )),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      PrayerTimeList(
                        timeOfCurrentlyPray: timeOfCurrentlyPray,
                        prayTimes: prayTimes,
                        prayerNames: _prayerNames,
                        prayerTimes: _prayerTimes,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: getScreenOfHeight * 0.02as double,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        containerOfHomePage(
                            context: context,
                            text: 'القرآن الكريم',
                            image: "assets/images/quran.png",
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) => Al_Quran_Al_Karim(
                                  tafaseerList: tafaseerList,
                                ),
                              ));
                            }),
                        containerOfHomePage(
                            context: context,
                            text: 'اذكار',
                            image: "assets/images/praying.png",
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) => AzkarPage(),
                              ));
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        containerOfHomePage(
                            context: context,
                            text: 'المسبحة الالكترونية',
                            image: "assets/images/rosary.png",
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) => ElectronicRosary(),
                              ));
                            }),
                        containerOfHomePage(
                            context: context,
                            text: 'الراديو',
                            image: "assets/images/radio.png",
                            onTap: () {
                              Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (_) => ListOfRadiosPage()));
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment:MainAxisAlignment.spaceAround ,
                      children: [
                        containerOfHomePage(
                          context: context,
                            text: 'الختمات السابقة',
                            image:"assets/images/before.png" ,
                            onTap: (){
                              Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) => ConclusionPage(
                                  nameOfPage: Constants.idOfConclusionPrivate,
                                ),
                              ));

                            }
                        ),
                        containerOfHomePage(
                            context: context,
                            text: 'ختمة جديدة',
                            image:"assets/images/add.png" ,
                            onTap: (){
                              Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) => New(),
                              ));
                            }
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment:MainAxisAlignment.spaceAround ,
                      children: [
                        SizedBox(
                          width: getScreenOfWidth * 0.4as double,
                          height: getScreenOfHeight * 0.2as double,
                        ),
                        containerOfHomePage(
                            context: context,
                            text: 'الختمات العامة',
                            image:"assets/images/community.png" ,
                            onTap: (){
                              Navigator.of(context).push(CupertinoPageRoute(
                                builder: (_) =>  ConclusionPage(
                                  nameOfPage: Constants.idOfConclusionPuplic,
                                ),
                              ));
                            }
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
