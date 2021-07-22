import 'dart:developer';

import 'package:al_wahab/controller/shared_preferences.dart';
import 'package:al_wahab/firebase/auth.dart';
import 'package:al_wahab/model/user.dart';
import 'package:al_wahab/veiws/login_signin/login_and_signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/location.dart';
import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/veiws/color_page.dart';
import 'package:al_wahab/veiws/home.dart';
import 'package:al_wahab/widgets/style_widget.dart';
import 'package:al_wahab/widgets/widgets.dart';

import 'change_theme_button_widget.dart';

Widget contOfDrawer(
    {ThemeProvider themeProvider,
    Widget title,
    Widget leading,
    Widget trailing,
    Function() onTap}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      decoration: BoxDecoration(
          color: themeProvider.showDark as bool
              ? Colors.grey.shade900
              : Constants.sceColor,
          boxShadow: [styleOfBoxShadow(blurRadius: 5)],
          borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onTap,
        title: title,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: leading,
        ),
        trailing: trailing,
      ),
    ),
  );
}

Widget widgetDrawer({@required BuildContext context}) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  Auth auth = Auth();
  return Drawer(
    child: SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: getScreenOfHeight / 3 as double,
                    decoration: BoxDecoration(
                      color: Color(Constants.mainColor),
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(40)),
                    ),
                  ),
                  if (DataOfUser.idOfUserInAppUser.isEmpty)
                    Row()
                  else
                    Positioned(
                        top: getScreenOfHeight * 0.13 as double,
                        left: getScreenOfWidth * 0.02 as double,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.all(
                                    getScreenOfWidth * 0.05 as double),
                                decoration: BoxDecoration(
                                  color: themeProvider.showDark
                                      ? Colors.grey.shade900
                                      : Constants.sceColor,
                                  shape: BoxShape.circle,
                                ),
                                child: widgetText(
                                    text: DataOfUser.nameInAppUser.isEmpty
                                        ? ''
                                        : DataOfUser.nameInAppUser[0]
                                            .toUpperCase(),
                                    fontSize: 50,
                                    fontWeight: FontWeight.w900,
                                    color: themeProvider.showDark
                                        ? Constants.sceColor
                                        : Colors.grey.shade900,
                                    textAlign: TextAlign.center)),
                            widgetText(
                              text: DataOfUser.nameInAppUser.isEmpty
                                  ? ''
                                  : DataOfUser.nameInAppUser,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: themeProvider.showDark
                                  ? Constants.sceColor
                                  : Colors.grey.shade900,
                            ),
                            widgetText(
                              text: DataOfUser.emailInAppUser.isEmpty
                                  ? ''
                                  : DataOfUser.emailInAppUser,
                              color: themeProvider.showDark
                                  ? Constants.sceColor
                                  : Colors.grey.shade900,
                            ),
                          ],
                        )),
                ],
              ),
              contOfDrawer(
                themeProvider: themeProvider,
                title: widgetText(
                    text: themeProvider.showDark ? 'Dark Theme' : 'Light Theme',
                    color: Color(Constants.mainColor)),
                leading: Image.asset(
                  themeProvider.showDark
                      ? 'assets/images/Isha.png'
                      : 'assets/images/Dhuhr.png',
                  alignment: Alignment.topLeft,
                  height: getScreenOfHeight * 0.05 as double,
                ),
                trailing: ChangeThemeButtonWidget(),
              ),
              contOfDrawer(
                  themeProvider: themeProvider,
                  title: widgetText(
                      text: 'Color ', color: Color(Constants.mainColor)),
                  trailing: null,
                  leading: Image.asset("assets/images/paint.png",
                      height: getScreenOfHeight * 0.05 as double),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (_) => ColorPage()));
                  }),
              contOfDrawer(
                  themeProvider: themeProvider,
                  title: widgetText(
                      text: 'Location ', color: Color(Constants.mainColor)),
                  trailing: null,
                  leading: Image.asset("assets/images/location.png",
                      height: getScreenOfHeight * 0.05 as double),
                  onTap: () {
                    log("Location>>>>>>>");
                    getPermissionOfLocation().then((v) {
                      log("getLocationOnLocationChanged");
                      getLocationOnLocationChanged();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => HomePage()));
                    });
                  }),
              contOfDrawer(
                  themeProvider: themeProvider,
                  title: widgetText(
                      text: DataOfUser.idOfUserInAppUser.isNotEmpty
                          ? 'تسجيل الخروج'
                          : 'تسجيل الدخول',
                      color: Color(Constants.mainColor)),
                  onTap: () {
                    if (DataOfUser.idOfUserInAppUser.isNotEmpty) {
                      auth.signOut().then((value) {
                        // addBookMark(offset: null,juz: null,id: null);
                        showSnackBarWidget(
                            context: context, text: 'تم تسجيل الخروج');
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => HomePage()));
                      });
                    } else {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (_) => LoginAndSignUpScreen()));
                    }
                  }),
            ],
          ),
        ],
      ),
    ),
  );
}
