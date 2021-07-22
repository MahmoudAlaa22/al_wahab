import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/quran_api.dart';
import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/model/quran.dart';
import 'package:al_wahab/veiws/quran/surah_index.dart';
import 'package:al_wahab/widgets/loading_shimmer.dart';
import 'package:al_wahab/widgets/style_widget.dart';
import 'package:al_wahab/widgets/widgets.dart';

class Al_Quran_Al_Karim extends StatefulWidget {
  List<Tafaseer> tafaseerList;

  Al_Quran_Al_Karim({@required this.tafaseerList});

  @override
  _Al_Quran_Al_KarimState createState() => _Al_Quran_Al_KarimState();
}

class _Al_Quran_Al_KarimState extends State<Al_Quran_Al_Karim> {
  String searchOfQuran = '';
  List quranToSet = [];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    log("tafaseerList.length is ${widget.tafaseerList.length}");
    return Scaffold(
      appBar: appBar(
        context: context,
        text: 'القرآن الكريم',
      ),
      body: FutureBuilder(
        future:
            DefaultAssetBundle.of(context).loadString('assets/json/quran.json'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingShimmer(
              text: "Surahs",
            );
          } else if (snapshot.hasError) {
            return Text("Error");
          } else {
            List<Surah> surahList =
            QuranApi.parseJson(snapshot.data.toString());
            // List t = [];
            // surahList.forEach((element) {
            //   if (element.name.contains(searchOfQuran)) {
            //     log(
            //         "element.name.contains(searchOfQuran is ${element.name}");
            //     t.add(element.name);
            //   }
            // });
            // quranToSet = t.toSet().toList();
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  color: Color(Constants.mainColor),
                  height: 2.0,
                );
              },
              // itemCount:snapshot.data.dateList.length,
              //  itemCount:snapshot.data.surahs.length,
              itemCount: surahList.length,
              itemBuilder: (_, i) {
                Surah surah = surahList[i];

                return Container(
                  decoration: BoxDecoration(
                      color: themeProvider.showDark
                          ? Colors.grey.shade900
                          : Colors.white,
                      boxShadow: [styleOfBoxShadow(blurRadius: 10)]),
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (_) => SurahIndex(
                            // quranAudio: quranAudio,
                            //     quranAudioAyah: quranAudioAyah,
                                surah: surahList,
                                index: i,
                                tafaseer: widget.tafaseerList,
                              )));
                    },
                    title: widgetText(
                        text: surah.name,
                        fontSize: size.width * 0.05,
                        color: themeProvider.showDark
                            ? Colors.white
                            : Colors.black),
                    leading: Padding(
                      padding: EdgeInsets.all(size.width * 0.02),
                      child: (surah.revelationType == "Meccan")
                          ? Image.asset("assets/images/Mecca.png")
                          : Image.asset("assets/images/Medina.png"),
                    ),
                    // Text("${surah.name}"),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
