
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/widgets/widget_animation.dart';

class LoadingShimmer extends StatelessWidget {
  final String text;
  const LoadingShimmer({this.text});
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Shimmer.fromColors(
      baseColor: Colors.transparent,
      highlightColor: Color(Constants.mainColor),
      enabled: true,
      child: Container(
        width: width,
        height: height,
        color: Colors.transparent,
        padding: EdgeInsets.all(8.0),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logo.png', height: height * 0.1),
            WidgetAnimator(
                Text("Loading $text..!", style: TextStyle(fontSize: height * 0.02)))
          ],
        )),
      ),
    );
  }
}
