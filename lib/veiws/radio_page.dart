import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/widgets/animation_page.dart';
import 'package:al_wahab/widgets/style_widget.dart';
import 'package:al_wahab/widgets/widgets.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class RadiosPage extends StatefulWidget {
  String nameOfRadio, radio_url;

  RadiosPage({this.nameOfRadio, this.radio_url});

  @override
  _RadiosPageState createState() => _RadiosPageState();
}

class _RadiosPageState extends State<RadiosPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  ThemeProvider themeProvider;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of(context);
  }

  void setupPlaylist() async {
    assetsAudioPlayer.open(
        Playlist(audios: [
          /// For playing local assets, add Audio('assets/music.mp3')
          /// For playing local file, add Audio.file('path/to/file')

          Audio.network(
              widget.radio_url,
              metas: Metas(title: widget.nameOfRadio,)),
        ]),
        showNotification: true,
        autoStart: true,

    );
  }
  @override
  void initState() {
    super.initState();
    setupPlaylist();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.forward();
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }
  playMusic() async {
    await assetsAudioPlayer.play();
  }

  pauseMusic() async {
    await assetsAudioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:appBar(text: widget.nameOfRadio,context: context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: getScreenOfWidth * 0.9as double,
            decoration: BoxDecoration(
                color:
                    themeProvider.showDark ? Colors.black : Constants.sceColor,
                boxShadow: [styleOfBoxShadow(blurRadius: 5)],
                shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Image.asset(
                'assets/images/microphone.png',
                color: Color(Constants.mainColor),
              ),
            ),
          ),
          Container(
            child: assetsAudioPlayer.builderIsPlaying(builder: (context, isPlaying){
              isPlaying ?_animationController.forward() :_animationController.reverse();
              return animationIcon(
                  colorOfCont: themeProvider.showDark?Colors.black:Colors.white,
                  progress: _animationController,
                  onTap: () {
                    isPlaying ? pauseMusic() : playMusic();
                  },
                  iconData: AnimatedIcons.play_pause);
            })
          )
        ],
      ),
    );
  }
}

