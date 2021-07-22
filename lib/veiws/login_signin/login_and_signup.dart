import 'dart:developer';

import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/shared_preferences.dart';
import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/firebase/auth.dart';
import 'package:al_wahab/firebase/store.dart';
import 'package:al_wahab/model/user.dart';
import 'package:al_wahab/widgets/style_widget.dart';
import 'package:al_wahab/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home.dart';

class LoginAndSignUpScreen extends StatefulWidget {
  @override
  _LoginAndSignUpScreenState createState() => _LoginAndSignUpScreenState();
}

class _LoginAndSignUpScreenState extends State<LoginAndSignUpScreen> {
  bool signUp = false, showPassword = false;
  ThemeProvider themeProvider;
  Auth _auth = Auth();
  String name, email, password, confirmPassword;
  final formKey = GlobalKey<FormState>();

  Store _store=Store();
  Widget widgetPadding(Widget widget) {
    return Padding(
      padding: EdgeInsets.only(
          left: getScreenOfWidth * 0.03 as double,
          right: getScreenOfWidth * 0.03 as double,
          top: getScreenOfWidth * 0.03 as double),
      child: widget,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of(context);
  }
  Widget widgetIcon({IconData iconData}) {
    return Icon(
      iconData,
      color: Color(Constants.mainColor),
    );
  }
 Future loginAndSignIn()async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      showDialog(context: context, builder: (_){
        return AlertDialog(
          title: Row(
            mainAxisAlignment:MainAxisAlignment.spaceAround ,
            children: [
              widgetText(text: 'Loading....',textDirection:TextDirection.ltr,
                color:themeProvider.isDarkMode ?  Colors.white:Colors.black ,  ),
              CircularProgressIndicator(),
            ],
          ),
        );
      });
      if (signUp) {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
          log("in createUserWithEmailAndPassword ");
          createFireBaseStore();
          saveDataOfUser(userUid: DataOfUser.idOfUserInAppUser,name: name,email: email);
          DataOfUser.nameInAppUser=name;
          DataOfUser.emailInAppUser=email;
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_)=>HomePage())
          );
        });
      } else {
       await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) {
         DataOfUser.getDataOfUser().then((value){
           DataOfUser.nameInAppUser=value[UserInFireBase.name] as String;
           DataOfUser.emailInAppUser=value[UserInFireBase.email] as String;
         }).then((value) {
           log("DataOfUser.nameInAppUser is ${DataOfUser.nameInAppUser}");
           saveDataOfUser(userUid: DataOfUser.idOfUserInAppUser,name: DataOfUser.nameInAppUser,email: email);
           Navigator.of(context).pop();
           showSnackBarWidget(context: context,text: 'تم تسجيل الدخول');
           Navigator.of(context).pushReplacement(
               MaterialPageRoute(builder: (_)=>HomePage())
           );
         });
         });

      }
      // DataOfUser.nameInAppUser=name;
      // DataOfUser.emailInAppUser=email;
      // DataOfUser.idOfUserInAppUser=Constants.userUid;
    }
  }
void createFireBaseStore(){
    log("LLLLLLLL");
  _store.addUser(
    email: email,
    name: name,
    idOfUser: DataOfUser.idOfUserInAppUser
  ).then((v){
    log("VVVVVVVVV");
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: getScreenOfWidth * 0.85as double,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                  border: Border.all(color: Color(Constants.mainColor)),
                  boxShadow: [styleOfBoxShadow(blurRadius: 5)],
                ),
                child: Column(
                  children: [
                    if (signUp) widgetPadding(
                            textFormField(
                                onChanged: (String v) {
                                  setState(() {
                                    name = v;
                                  });
                                },
                                validator: (String v) {
                                  if (v.isEmpty) {
                                    return Constants.massageOfValidator;
                                  }
                                },
                                textDirection: TextDirection.ltr,
                                labelText: 'Name',
                                prefixIcon:
                                    widgetIcon(iconData: Icons.person_pin),
                                autofocus: false,
                                borderRadius: 40.0),
                          ) else Row(),
                    widgetPadding(
                      textFormField(
                          onChanged: (String v) {
                            setState(() {
                              email = v;
                            });
                          },
                          validator: (String v) {
                            if (v.isEmpty) {
                              return Constants.massageOfValidator;
                            }
                          },
                          textDirection: TextDirection.ltr,
                          labelText: 'Email',
                          prefixIcon: widgetIcon(iconData: Icons.email),
                          autofocus: false,
                          borderRadius: 40.0),
                    ),
                    widgetPadding(
                      textFormField(
                          onChanged: (String v) {
                            setState(() {
                              password = v;
                            });
                          },
                          validator: (String v) {
                            if (v.isEmpty) {
                              return Constants.massageOfValidator;
                            }
                          },
                          textDirection: TextDirection.ltr,
                          maxLines: 1,
                          labelText: 'Password',
                          prefixIcon: widgetIcon(iconData: Icons.lock),
                          autofocus: false,
                          borderRadius: 40.0,
                          suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              child: widgetIcon(
                                  iconData: !showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                          obscureText: !showPassword),
                    ),
                    if (signUp) widgetPadding(
                            textFormField(
                                onChanged: (String v) {
                                  setState(() {
                                    confirmPassword = v;
                                  });
                                },
                                validator: (String v) {
                                  log("$password == $v");
                                  if (v.isEmpty) return Constants.massageOfValidator;
                                  if (v != password) {
                                    return "The password you entered does not match";
                                  }
                                },
                                textDirection: TextDirection.ltr,
                                maxLines: 1,
                                labelText: 'Confirm Password',
                                prefixIcon: widgetIcon(iconData: Icons.lock),
                                autofocus: false,
                                borderRadius: 40.0,
                                suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                    child: widgetIcon(
                                        iconData: !showPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                obscureText: !showPassword),
                          ) else Row(),
                    widgetPadding(
                      GestureDetector(
                        onTap: () {
                          loginAndSignIn();
                        },
                        child: Container(
                          width: getScreenOfWidth * 0.3as double,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Color(Constants.mainColor)),
                          child: widgetText(
                              text: signUp ? "SIGNUP" : "LOGIN",
                              color: Colors.white,
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                    widgetPadding(GestureDetector(
                        onTap: () {
                          setState(() {
                            signUp = !signUp;
                          });
                          // loginAndSignIn();
                        },
                        child: widgetText(
                            text: signUp ? "LOGIN" : "SIGNUP",
                            color: Color(Constants.mainColor),
                            textAlign: TextAlign.center))),
                    SizedBox(
                      height: getScreenOfHeight * 0.02as double,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
