import 'dart:developer';
import 'dart:ffi';

import 'package:al_wahab/controller/get_data/get_quran_data.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/quran_api.dart';
import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/widgets/animation_page.dart';
import 'package:al_wahab/widgets/style_widget.dart';
import 'package:al_wahab/model/quran.dart';
import 'package:al_wahab/widgets/widgets.dart';


class SurahIndex extends StatefulWidget {
  final List<Surah> surah;
  final int index;
  final List<Tafaseer> tafaseer;
  // QuranAudio quranAudio = QuranAudio();
  // QuranAudioAyah quranAudioAyah = QuranAudioAyah();
  SurahIndex({this.surah, this.tafaseer, this.index,
    // @required this.quranAudio,@required this.quranAudioAyah
  });

  @override
  _SurahIndexState createState() => _SurahIndexState();
}

class _SurahIndexState extends State<SurahIndex>
    with SingleTickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();
  bool playing = false;
  // QuranApi _quranApi = QuranApi();

  // QuranAudio quranAudio = QuranAudio();
  // QuranAudioAyah quranAudioAyah = QuranAudioAyah();
  AudioPlayerState audioPlayerState = AudioPlayerState.PAUSED;
  List<AudioOfSurah> listAudioOfSurah = [];
  List<String> tafseerList = [];
  Duration du = Duration();
  Duration pos = Duration();
  String playAudio = '';
  String nameOfReciters = '', rewayaOfReciter = '';
  AnimationController _animationController;
  ThemeProvider themeProvider;
  String ayahs = '';
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  List wayToShow = ['مفسر', 'مجود'];
  String valueChose = 'مجود';

  Widget dropdownButton({valueOfDrop, ValueChanged onChanged, List items}) {
    return Row(
      children: [
        SizedBox(
          width: getScreenOfWidth * 0.2 as double,
          child: dropdownButtonWidget(
              valueOfDrop: valueOfDrop, onChanged: onChanged, items: items),
        ),
        widgetText(text: 'طريقه عرض السوره', color: Color(Constants.mainColor))
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of(context);
  }

  Future<void> getTafseer() async {
    for (int i = 0; i < widget.tafaseer.length; i++) {
      if (widget.surah[widget.index].number == widget.tafaseer[i].sura) {
        // log("widget.tafaseer[i].aya is ${widget.tafaseer[i].aya}");
        setState(() {
          tafseerList.add(widget.tafaseer[i].text);
        });
      }
    }
  }

  void setupPlaylist(
      {String url, String nameOfReciters, String rewayaOfReciter}) async {
    assetsAudioPlayer.current.listen((playingAudio) {
      setState(() {
        du = playingAudio.audio.duration;
      });
    });
    assetsAudioPlayer.currentPosition.listen((playingAudio) {
      setState(() {
        pos = playingAudio;
      });
    });
    assetsAudioPlayer.open(
      Playlist(audios: [
        /// For playing local assets, add Audio('assets/music.mp3')
        /// For playing local file, add Audio.file('path/to/file')

        Audio.network(url,
            metas: Metas(
                title: widget.surah[widget.index].name,
                artist: nameOfReciters,
                album: rewayaOfReciter)),
      ]),
      showNotification: true,
      autoStart: false,
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    // _quranApi.getAudioOfSurah().then((value) {
    //   setState(() {
    //     log("value is $value");
    //     quranAudio = value;
    //     for (int i = 0; i < quranAudio.audioOfSurahList.length; i++) {
    //       // log("in for loop is ${quranAudio.audioOfSurahList[i].suras}");
    //       if (quranAudio.audioOfSurahList[i].suras
    //           .contains("${widget.surah[widget.index].number}")) {
    //         listAudioOfSurah.add(quranAudio.audioOfSurahList[i]);
    //         // log("quranAudio.audioOfSurahList[i].id is ${quranAudio.audioOfSurahList[i].id}");
    //       }
    //     }
    //     if (listAudioOfSurah.isNotEmpty) {
    //       playAudio =
    //           "${listAudioOfSurah[0].Server}/${widget.surah[widget.index].number.toString().padLeft(3, "0")}.mp3";
    //       nameOfReciters = listAudioOfSurah[0].name;
    //       rewayaOfReciter = listAudioOfSurah[0].rewaya;
    //       setupPlaylist(
    //           url: playAudio,
    //           nameOfReciters: nameOfReciters,
    //           rewayaOfReciter: rewayaOfReciter);
    //     }
    //   });
    // });
    // _quranApi.getAudioOfAyah().then((value) {
    //   setState(() {
    //     quranAudioAyah = value;
    //   });
    // });
    getAudioOfSurah();
    getTafseer();
    for (int i = 0; i < widget.surah[widget.index].ayahs.length; i++) {
      setState(() {
        ayahs +=
            "${(widget.surah[widget.index].ayahs[i].text.contains(basmala) && widget.surah[widget.index].number != 1) ? "${widget.surah[widget.index].ayahs[i].text.substring(basmala.length)} ﴿${i + 1}﴾ " : "${widget.surah[widget.index].ayahs[i].text} ﴿${i + 1}﴾"} ";
      });
    }
  }
  void getAudioOfSurah(){
    if(GetQuranData.quranAudioAyah!=null){
      setState(() {
        for (int i = 0; i < GetQuranData.quranAudio.audioOfSurahList.length; i++) {
          // log("in for loop is ${quranAudio.audioOfSurahList[i].suras}");
          if ( GetQuranData.quranAudio.audioOfSurahList[i].suras
              .contains("${widget.surah[widget.index].number}")) {
            listAudioOfSurah.add( GetQuranData.quranAudio.audioOfSurahList[i]);
            // log("quranAudio.audioOfSurahList[i].id is ${quranAudio.audioOfSurahList[i].id}");
          }
        }
        if (listAudioOfSurah.isNotEmpty) {
          playAudio =
          "${listAudioOfSurah[0].Server}/${widget.surah[widget.index].number.toString().padLeft(3, "0")}.mp3";
          nameOfReciters = listAudioOfSurah[0].name;
          rewayaOfReciter = listAudioOfSurah[0].rewaya;
          setupPlaylist(
              url: playAudio,
              nameOfReciters: nameOfReciters,
              rewayaOfReciter: rewayaOfReciter);
        }
      });
    }
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Compulsory
  playMusic(String url) async {
    log("url of Audio is $url");
    assetsAudioPlayerPauseMusic();
    await audioPlayer.play(url);
  }

  /// Compulsory
  pauseMusic() async {
    await audioPlayer.pause();
  }

  assetsAudioPlayerPlayMusic() async {
    audioPlayer.pause();
    await assetsAudioPlayer.play();
  }

  assetsAudioPlayerPauseMusic() async {
    await assetsAudioPlayer.pause();
  }

  playAyah({ayat}) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: getScreenOfHeight / 2 as double,
            child: ( GetQuranData.quranAudioAyah.listRecitersVerse != null)
                ? ListView.separated(
                    itemBuilder: (context, i) {
                      final listRecitersVerse =
                      GetQuranData.quranAudioAyah.listRecitersVerse[i];
                      if (listRecitersVerse.audio_url_bit_rate_32_ == "" &&
                          listRecitersVerse.audio_url_bit_rate_64 == "0" &&
                          listRecitersVerse.audio_url_bit_rate_128 == "0") {
                        return Row();
                      }
                      return ListTile(
                        onTap: () {
                          try {
                            setState(() {
                              if (listRecitersVerse.audio_url_bit_rate_32_ !=
                                  "") {
                                playAudio =
                                    "${listRecitersVerse.audio_url_bit_rate_32_}${widget.surah[widget.index].number.toString().padLeft(3, "0")}${ayat.number.toString().padLeft(3, "0")}.mp3";
                                log(
                                    "listRecitersVerse.audio_url_bit_rate_32 is ${playAudio}");
                              } else if (listRecitersVerse
                                      .audio_url_bit_rate_64 !=
                                  "") {
                                playAudio =
                                    "${listRecitersVerse.audio_url_bit_rate_64}${widget.surah[widget.index].number.toString().padLeft(3, "0")}${ayat.number.toString().padLeft(3, "0")}.mp3";
                                log(
                                    "listRecitersVerse.audio_url_bit_rate_64 is ${playAudio}");
                              } else if (listRecitersVerse
                                      .audio_url_bit_rate_128 !=
                                  "") {
                                playAudio =
                                    "${listRecitersVerse.audio_url_bit_rate_128}${widget.surah[widget.index].number.toString().padLeft(3, "0")}${ayat.number.toString().padLeft(3, "0")}.mp3";
                                log(
                                    "listRecitersVerse.audio_url_bit_rate_128 is ${playAudio}");
                              }
                            });
                            playMusic(playAudio);
                            // _animationController.forward();
                            // nameOfReciters =
                            //     listRecitersVerse.name;
                            // rewayaOfReciter =
                            //     listRecitersVerse
                            //         .rewaya;
                            Navigator.of(context).pop();
                          } catch (e) {
                            log("The Error is $e");
                          }
                        },
                        leading: Text(listRecitersVerse.name.toString()),
                        trailing: Text(listRecitersVerse.rewaya),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Color(Constants.mainColor),
                        height: 2.0,
                      );
                    },
                    itemCount:  GetQuranData.quranAudioAyah.listRecitersVerse.length - 1)
                : Center(child: CircularProgressIndicator()),
          );
        });
  }

  Widget buttonOfRow({Widget w1, Widget w2, Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          w1,
          w2,
        ],
      ),
    );
  }

  Widget widgetView() {
    if (valueChose == 'مجود') {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: getScreenOfHeight * 0.03 as double,
            horizontal: getScreenOfWidth * 0.02 as double),
        child: Column(
          children: [
            if (widget.surah[widget.index].number != 1 &&
                widget.surah[widget.index].number != 9)
              widgetText(
                  text: basmala,
                  color: themeProvider.isDarkMode
                      ? Constants.sceColor
                      : Colors.grey.shade900,
                  fontSize: getScreenOfWidth * 0.065 as double,
                  fontWeight: FontWeight.w700)
            else
              Row(),
            widgetText(
              text: ayahs,
              fontSize: getScreenOfWidth * 0.055 as double,
              fontWeight: FontWeight.w500,
              color: themeProvider.isDarkMode
                  ? Constants.sceColor
                  : Colors.grey.shade900,
            )
          ],
        ),
      );
    } else {
      return ListView.separated(
          padding: EdgeInsets.only(bottom: getScreenOfHeight * 0.03 as double),
          separatorBuilder: (context, index) {
            return Divider(
              color: Color(Constants.mainColor),
              height: 2.0,
            );
          },
          itemCount: widget.surah[widget.index].ayahs.length,
          itemBuilder: (_, i) {
            Ayat ayat = widget.surah[widget.index].ayahs[i];
            String textOfAyah =
                (i == 0 && ayat.text.contains(basmala) && widget.surah[widget.index].number != 1) ? "${ayat.text.substring(basmala.length)} ﴿${i + 1}﴾" : "${ayat.text} ﴿${i + 1}﴾";
            return Stack(
              children: [
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (i == 0 &&
                        ayat.text.contains(basmala) &&
                        widget.surah[widget.index].number != 1)
                      widgetText(
                          text: basmala,
                          fontSize: getScreenOfWidth * 0.07 as double,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                          color: themeProvider.showDark
                              ? Colors.white
                              : Colors.black)
                    else
                      Row(),
                    ListTile(
                        contentPadding: EdgeInsets.only(
                            left: getScreenOfWidth * 0.04 as double,
                            right: getScreenOfWidth * 0.02 as double,
                            top: getScreenOfHeight * 0.02 as double),
                        onTap: () {
                          playAyah(ayat: ayat);
                        },
                        title: Wrap(
                          textDirection: TextDirection.rtl,
                          runAlignment: WrapAlignment.center,
                          children: [
                            widgetText(
                                text: textOfAyah,
                                fontSize: getScreenOfWidth * 0.06 as double,
                                color: themeProvider.showDark
                                    ? Colors.white
                                    : Colors.black),
                          ],
                        )),
                  ],
                ),
                InkWell(
                  child:  Icon(
                    Icons.menu_book,
                    size: 30,
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return Container(
                            height: getScreenOfHeight / 2 as double,
                            padding: EdgeInsets.all(
                                getScreenOfWidth * 0.01 as double),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  widgetText(
                                      text: textOfAyah,
                                      fontSize: 20,
                                      color: themeProvider.showDark
                                          ? Colors.white
                                          : Colors.black),
                                  widgetText(
                                      text: tafseerList[i],
                                      textDirection: TextDirection.rtl,
                                      fontSize:
                                          getScreenOfWidth * 0.06 as double,
                                      color: themeProvider.showDark
                                          ? Color(Constants.mainColor)
                                          : Colors.black),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: appBar(
            text: widget.surah[widget.index].name,
            context: context,
            actions: [
              dropdownButton(
                  items: wayToShow,
                  onChanged: (v) {
                    setState(() {
                      valueChose = v as String;
                    });
                  },
                  valueOfDrop: valueChose)
            ],
            elevation: 0.0),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: getScreenOfHeight * 0.05 as double),
              child: Column(
                children: [
                  Expanded(child: widgetView()),
                  SizedBox(
                    height: getScreenOfHeight * 0.20 as double,
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: getScreenOfHeight * 0.2 as double,
                decoration: BoxDecoration(
                    color: Color(Constants.mainColor),
                    borderRadius: BorderRadius.only(
                        topRight:
                            Radius.circular(getScreenOfWidth * 0.05 as double),
                        topLeft:
                            Radius.circular(getScreenOfWidth * 0.05 as double)),
                    boxShadow: [BoxShadow(blurRadius: 5)]),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              widgetText(
                                text: "رواية",
                              ),
                              widgetText(
                                  text:
                                      (listAudioOfSurah.isNotEmpty) ? rewayaOfReciter : "loading...",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ],
                          ),
                          Column(
                            children: [
                              widgetText(text: " قارئ السورة"),
                              widgetText(
                                  text:
                                      (listAudioOfSurah.isNotEmpty) ? nameOfReciters : "loading...",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          assetsAudioPlayer.builderCurrentPosition(
                              builder: (context, duration) {
                            // pos=duration;
                            return widgetText(
                                text: duration.toString().substring(0, 7));
                          }),
                          Expanded(
                            child: Slider.adaptive(
                                activeColor: Colors.white,
                                inactiveColor: Colors.black,
                                value: pos.inSeconds.toDouble(),
                                min: 0.0,
                                max: du.inSeconds.toDouble(),
                                onChanged: (value) {
                                  assetsAudioPlayer
                                      .seek(Duration(seconds: value.toInt()));
                                }),
                          ),
                          widgetText(text: du.toString().substring(0, 7)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return Container(
                                height: getScreenOfHeight / 2 as double,
                                child: (listAudioOfSurah.isNotEmpty)
                                    ? ListView.separated(
                                        itemBuilder: (context, i) {
                                          return ListTile(
                                            onTap: () {
                                              setState(() {
                                                nameOfReciters =
                                                    listAudioOfSurah[i].name;
                                                rewayaOfReciter =
                                                    listAudioOfSurah[i].rewaya;
                                                playAudio =
                                                    "${listAudioOfSurah[i].Server}/${widget.surah[widget.index].number.toString().padLeft(3, "0")}.mp3";
                                              });
                                              // playMusic(playAudio);
                                              setupPlaylist(
                                                  url: playAudio,
                                                  nameOfReciters:
                                                      nameOfReciters,
                                                  rewayaOfReciter:
                                                      rewayaOfReciter);
                                              _animationController.forward();
                                              Navigator.of(context).pop();
                                            },
                                            leading: Text(
                                                listAudioOfSurah[i].name),
                                            trailing: Text(
                                                listAudioOfSurah[i].rewaya),
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return Divider(
                                            color: Color(Constants.mainColor),
                                            height: 2.0,
                                          );
                                        },
                                        itemCount: listAudioOfSurah.length)
                                    : Center(
                                        child: CircularProgressIndicator()),
                              );
                            });
                      },
                      child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(blurRadius: 5)]),
                          child: widgetText(
                              text: "اختر اسم القارئ",
                              color: Color(Constants.mainColor))),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: getScreenOfHeight * 0.17 as double,
              left: 50,
              right: 50,
              child: Container(
                child: assetsAudioPlayer.builderIsPlaying(
                    builder: (context, isPlaying) {
                  isPlaying || audioPlayerState == AudioPlayerState.PLAYING
                      ? _animationController.forward()
                      : _animationController.reverse();
                  return animationIcon(
                      colorOfCont:
                          themeProvider.showDark ? Colors.black : Colors.white,
                      progress: _animationController,
                      onTap: () {
                        isPlaying
                            ? assetsAudioPlayerPauseMusic()
                            : assetsAudioPlayerPlayMusic();
                      },
                      iconData: AnimatedIcons.play_pause);
                }),
              ),
              // child: animationIcon(
              //     progress: _animationController,
              //     onTap: () {
              //       if (audioPlayerState ==
              //               AudioPlayerState
              //                   .PLAYING)
              //         _animationController.reverse();
              //       else
              //         _animationController.forward();
              //       audioPlayerState == AudioPlayerState.PLAYING
              //           ? pauseMusic()
              //           : playMusic(playAudio);
              //     },
              //     iconData: AnimatedIcons.play_pause),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                height: getScreenOfHeight * 0.05 as double,
                width: getScreenOfWidth as double,
                decoration: BoxDecoration(
                    color: themeProvider.showDark ? Colors.black : Colors.white,
                    boxShadow: const [
                      BoxShadow(blurRadius: 3, spreadRadius: -0.5)
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buttonOfRow(
                        w1: widgetText(
                            text: 'السابق', color: Color(Constants.mainColor)),
                        w2: const Icon(Icons.arrow_back_ios_outlined),
                        onTap: () {
                          if (widget.index == 0) {
                            showSnackBarWidget(
                                context: context,
                                text: 'لا يوجد سور اخري قبل هذه السوره');
                          } else {
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => SurahIndex(
                                          index: widget.index - 1,
                                          surah: widget.surah,
                                          tafaseer: widget.tafaseer,
                                        )));
                          }
                        }),
                    buttonOfRow(
                        w1: const Icon(Icons.arrow_forward_ios_outlined),
                        w2: widgetText(
                            text: 'التالي', color: Color(Constants.mainColor)),
                        onTap: () {
                          if (widget.index == 143) {
                            showSnackBarWidget(
                                context: context,
                                text: 'لا يوجد سور بعد هذه السوره');
                          } else {
                            Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => SurahIndex(
                                          index: widget.index + 1,
                                          surah: widget.surah,
                                          tafaseer: widget.tafaseer,
                                        )));
                          }
                        }),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
