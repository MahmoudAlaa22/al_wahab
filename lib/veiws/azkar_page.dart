import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_wahab/controller/azkar_api.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/model/azkar.dart';
import 'package:al_wahab/veiws/zekr.dart';
import 'package:al_wahab/widgets/loading_shimmer.dart';
import 'package:al_wahab/widgets/style_widget.dart';
import 'package:al_wahab/widgets/widgets.dart';

class AzkarPage extends StatefulWidget {
  @override
  _AzkarPageState createState() => _AzkarPageState();
}

class _AzkarPageState extends State<AzkarPage> {
  List azkarToSet = [];
  bool _showSearch = false;
  String searchOfAzkar = '';
  ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider=Provider.of(context);
  }
  Widget contaierOfAzkar({List<Azkar> azkar, int i}) {
    return Container(
      decoration: BoxDecoration(
          color: themeProvider.showDark?Colors.grey.shade900:Colors.white,
          boxShadow: [styleOfBoxShadow(blurRadius: 10)]),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (_) => Zekr(
                    category: azkarToSet[i]as String,
                    azkar: azkar,
                  )));
        },
        title: widgetText(text: azkarToSet[i]as String, fontWeight: FontWeight.bold,
        color: themeProvider.showDark?Color(Constants.mainColor):Colors.black
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },child: Icon(Icons.arrow_back_ios,
            color:Color(Constants.mainColor)),
        ),
        title: _showSearch
            ? searchingTextFormField(onChanged: (String v) {
                setState(() {
                  searchOfAzkar = v;
                });
              })
            : widgetText(text: "اذكار", color: Color(Constants.mainColor)),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _showSearch = !_showSearch;
                  if(!_showSearch)searchOfAzkar='';
                });
              },
              icon: Icon(!_showSearch?Icons.search:Icons.clear,color:Color(Constants.mainColor) ,))
        ],
      ),
      body: FutureBuilder(
        future:
            DefaultAssetBundle.of(context).loadString('assets/json/azkar.json'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingShimmer(
              text: "اذكار",
            );
          } else {
            List<Azkar> _azkar =
                AzkarApi().azkarParseJson(snapshot.data.toString());
            List t = [];
            _azkar.forEach((element) {
              if (element.category.contains(searchOfAzkar)as bool) {
                log(
                    "element.category.contains(searchOfAzkar is ${element.category}");
                t.add(element.category);
              }
            });
            azkarToSet = t.toSet().toList();
            return Container(
              child: ListView.separated(
                  separatorBuilder: (context, i) {
                    return Divider(
                      color: Color(Constants.mainColor),
                      height: 2.0,
                    );
                  },
                  itemCount: azkarToSet.length,
                  itemBuilder: (context, i) {
                    return contaierOfAzkar(azkar: _azkar, i: i);
                  }),
            );
          }
        },
      ),
    );
  }
}
