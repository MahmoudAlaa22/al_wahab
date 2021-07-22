import 'package:flutter/material.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/widgets/widgets.dart';
Widget animationIcon({double sizeIcon:40.0,
  Animation<double> progress,Function() onTap,Color colorOfCont:Colors.white,AnimatedIconData iconData}){
  return Container(
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:colorOfCont,
      boxShadow: [
        styleOfBoxShadow(blurRadius: 5)
      ]
    ),
    child: Center(
      child: InkWell(
        child: AnimatedIcon(
          color: Color(Constants.mainColor),
          icon: iconData,
          size: sizeIcon,
          progress: progress,
        ),
        // New: handle onTap event
        onTap: onTap
      ),
    ),
  );
}

Widget animationButton({
  BorderRadiusGeometry borderRadius,@required Color color,
  int milliseconds:100,Function() onTap,Function() onEnd,double width,double height,BoxShape shape,Widget child }){
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      onEnd: onEnd,
      duration: Duration(milliseconds: milliseconds),
      curve: Curves.linear,
      width: width,
      height:height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
          shape: shape,
          color: color,
          boxShadow: [BoxShadow(blurRadius: 5,offset: Offset(2,3))]
      ),
      child: child,
    ),
  );
}