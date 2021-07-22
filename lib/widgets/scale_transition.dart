import 'dart:developer';

import 'package:al_wahab/controller/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/provider.dart';

class WidgetOfScaleTransition extends StatefulWidget {
  Widget child;
  WidgetOfScaleTransition({@required this.child});

  @override
  _WidgetOfScaleTransitionState createState() => _WidgetOfScaleTransitionState();
}

class _WidgetOfScaleTransitionState extends State<WidgetOfScaleTransition> with SingleTickerProviderStateMixin{
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
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    log("Constants.listOfZekr is ${Constants.listOfZekr}");
    return ScaleTransition(
      scale:scaleAnimation,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: widget.child,
        ),
      ),
    );
  }
}
