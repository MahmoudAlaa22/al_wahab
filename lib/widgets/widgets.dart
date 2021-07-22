import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/widgets/style_widget.dart';

import '../controller/constant.dart';

BoxShadow styleOfBoxShadow({double blurRadius}) {
  return BoxShadow(blurRadius: blurRadius, offset: Offset(2, 3), spreadRadius: 1,color:Color(Constants.mainColor));
}


Widget containerOfHomePage({String image,String text, Function() onTap,@required BuildContext context}) {
  final themeProvider = Provider.of<ThemeProvider>(context);

  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: getScreenOfWidth * 0.4as double,
      height: getScreenOfHeight * 0.2as double,
      padding: EdgeInsets.all(getScreenOfWidth*0.02as double),
      decoration: BoxDecoration(
        color: themeProvider.showDark?Colors.black:Constants.sceColor,
        boxShadow: [styleOfBoxShadow(blurRadius: 5)],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment:MainAxisAlignment.spaceBetween ,
        children: [
          widgetText(
              text: text, fontSize:getScreenOfWidth*0.05as double,
              color: Color(Constants.mainColor)
          ),
          Image.asset(image,color: Color(Constants.mainColor),
          height: getScreenOfHeight*0.09as double)

        ],
      ),
    ),
  );
}
Widget searchingTextFormField({ValueChanged<String> onChanged}){
  return TextFormField(
    autofocus: true,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: "Searching...",
      hintStyle: TextStyle(color: Color(Constants.mainColor)),
      border: InputBorder.none
    ),
  );
}
TextFormField textFormField({
  bool obscureText:false,TextDirection textDirection:TextDirection.rtl,
  double borderRadius:10,int maxLines:3,Widget prefixIcon,Widget suffixIcon,
  String initialValue, bool autofocus,String labelText,
  ValueChanged<String> onChanged,FormFieldValidator<String> validator,TextInputType keyboardType}){
  return TextFormField(
    initialValue: initialValue,
    minLines: 1,
    maxLines: maxLines,
    autofocus: autofocus,
    textDirection:textDirection ,
    cursorColor: Color(Constants.mainColor),
    keyboardType: keyboardType,
    obscureText:obscureText ,
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      labelText: labelText,
      labelStyle: TextStyle(color: Color(Constants.mainColor)),
      focusedBorder:OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: Color(Constants.mainColor)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: Color(Constants.mainColor)),
      ),
    ),
    onChanged: onChanged,
    validator:validator ,
  );
}

AppBar appBar({double elevation=4.0, String text,@required BuildContext context,List<Widget> actions}){
  return AppBar(
    elevation: elevation,
    title: widgetText(text: text,color: Color(Constants.mainColor)),
    leading: InkWell(
    onTap: (){
      Navigator.of(context).pop(true);
    },child: Icon(Icons.arrow_back_ios,color:Color(Constants.mainColor) ,),
    ),
    actions:actions,
  );
}
void showSnackBarWidget({@required BuildContext context,String text}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(milliseconds: 900),
    backgroundColor: Color(Constants.mainColor),
    content: widgetText(text: text,color: Colors.white),
  ));
}
Widget dropdownButtonWidget({valueOfDrop,ValueChanged onChanged, List items}){
  return DropdownButton(
    style: TextStyle(color: Color(Constants.mainColor)),
    iconDisabledColor: Color(Constants.mainColor),
    iconEnabledColor: Color(Constants.mainColor),
    iconSize: 30.0,
    underline: const SizedBox(),
    isExpanded: true,
    value: valueOfDrop,
    onChanged: onChanged,
    items: items
        .map((e) => DropdownMenuItem(value: e, child: Text(e as String)))
        .toList(),
  );
}

