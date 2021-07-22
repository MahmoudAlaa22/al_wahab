import 'package:al_wahab/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/provider.dart';
import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/veiws/add_zekr.dart';
import 'package:al_wahab/widgets/animation_page.dart';
import 'package:al_wahab/widgets/style_widget.dart';

class Rosary extends StatefulWidget {
  String zekr;
  int countOfZekr;
  Rosary({this.countOfZekr,this.zekr});
  @override
  _RosaryState createState() => _RosaryState();
}

class _RosaryState extends State<Rosary> {
  double width = getScreenOfWidth * 0.7as double;
  double width2 = getScreenOfWidth * 0.15as double;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar:appBar(context: context,text: "السبحة"),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              widgetText(
                  text: "${widget.zekr}",
                  textAlign: TextAlign.center,
                color: Color(Constants.mainColor)
              ), widgetText(
                  text: "${widget.countOfZekr}",
                  textAlign: TextAlign.center,
                  color: Color(Constants.mainColor)
              ),
              widgetText(
                  text: "$count",
                  textAlign: TextAlign.center,
                  fontSize: getScreenOfWidth * 0.3as double,
                color: Color(Constants.mainColor)
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: animationButton(
                      color: Color(Constants.mainColor),
                      onTap: (){
                        setState(() {
                          width2=getScreenOfWidth * 0.13as double;
                          count=0;
                        });
                      },
                        onEnd: (){
                          setState(() {
                            width2=getScreenOfWidth * 0.15as double;
                          });
                        },
                        child: Icon(
                          Icons.replay,
                          color: themeProvider.showDark?Colors.black:Colors.white,
                          size: getScreenOfWidth * 0.1as double,
                        ),
                        shape: BoxShape.circle,
                        width: width2,
                        height: width2)),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    width = getScreenOfWidth * 0.6as double;
                    if(count>=widget.countOfZekr) {
                      count=widget.countOfZekr;
                    } else {
                      count++;
                    }
                  });
                },
                child: AnimatedContainer(
                  onEnd: () {
                    setState(() {
                      width = getScreenOfWidth * 0.7as double;
                    });
                  },
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.linear,
                  width: width,
                  height: width,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (count>=widget.countOfZekr)?Colors.red:Color(Constants.mainColor),
                      boxShadow: const[ BoxShadow(blurRadius: 5, offset: Offset(2, 3))]),
                  child: SizedBox(
                    height: getScreenOfHeight * 0.6as double,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
