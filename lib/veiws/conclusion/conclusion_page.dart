import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/firebase/store.dart';
import 'package:al_wahab/model/user.dart';
import 'package:al_wahab/widgets/style_widget.dart';
import 'package:al_wahab/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'juz.dart';

class ConclusionPage extends StatefulWidget {
  final String nameOfPage;
  const ConclusionPage({@required this.nameOfPage});
  @override
  _ConclusionPageState createState() => _ConclusionPageState();
}

class _ConclusionPageState extends State<ConclusionPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: appBar(context: context, text: 'الختمات العامة'),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(collectionOfNewConclusion)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<QueryDocumentSnapshot> listOfConclusion = snapshot.data.docs;
            List readersList;
            bool r=true;
            return ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  color: Color(Constants.mainColor),
                  height: 2.0,
                );
              },
              itemCount: snapshot.data.docs.length,
              itemBuilder: (_, i) {
               if(Constants.idOfConclusionPrivate==widget.nameOfPage){
                 r=false;
                 readersList=listOfConclusion[i][Conclusion.readers] as List;
                 for(int j=0;j<readersList.length;j++){
                   if(readersList[j][Readers.id]==DataOfUser.idOfUserInAppUser){
                     r=true;
                   }
                 }
               }
                // log("<<<<<>>>>>${listOfConclusion[i][Conclusion.readers][0]['id']}");
                return !r?Row():Container(
                  decoration: BoxDecoration(
                      color: themeProvider.showDark
                          ? Colors.grey.shade900
                          : Colors.white,
                      boxShadow: [styleOfBoxShadow(blurRadius: 5)]),
                  child: ListTile(
                    onTap: (){
                      Navigator.of(context).push(
                          CupertinoPageRoute(builder: (_)=>Juz(
                            id: listOfConclusion[i].id,
                          ))
                      );
                    },
                    title: widgetText(
                      text:
                      "${listOfConclusion[i][Conclusion.title]} ${listOfConclusion[i][Conclusion.name]}",
                      color: themeProvider.showDark
                          ? Colors.white
                          : Colors.grey.shade900,
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
