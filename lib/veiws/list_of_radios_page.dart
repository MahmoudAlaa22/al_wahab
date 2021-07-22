import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:al_wahab/controller/constant.dart';
import 'package:al_wahab/controller/radio_api.dart';
import 'package:al_wahab/controller/theme_provider.dart';
import 'package:al_wahab/model/radio_model.dart';
import 'package:al_wahab/veiws/radio_page.dart';
import 'package:al_wahab/widgets/loading_shimmer.dart';
import 'package:al_wahab/widgets/style_widget.dart';
import 'package:al_wahab/widgets/widgets.dart';

class ListOfRadiosPage extends StatefulWidget {
  @override
  _ListOfRadiosPageState createState() => _ListOfRadiosPageState();
}

class _ListOfRadiosPageState extends State<ListOfRadiosPage> {
  RadioApi radioApi = RadioApi();
  List<RadioModel> listRadioModel = [];
  ThemeProvider themeProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of(context);
  }

  @override
  void initState() {
    super.initState();
    radioApi.getAudioOfRadio().then((value) {
      setState(() {
        listRadioModel = value.listRadioModel;
      });
      log("*** value is ${value.listRadioModel}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:appBar(text: 'الراديو',context: context),
      body: Container(
        child: listRadioModel.isNotEmpty
            ? ListView.separated(
                itemBuilder: (_, i) {
                  return Container(
                    decoration: BoxDecoration(
                      color: themeProvider.showDark?Colors.grey.shade900:Colors.white,
                      boxShadow: [styleOfBoxShadow(blurRadius: 10)],),
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                            builder: (_) => RadiosPage(
                                  nameOfRadio: listRadioModel[i].name,
                                  radio_url: listRadioModel[i].radio_url,
                                )));
                      },
                      title: widgetText(text: listRadioModel[i].name,color: themeProvider.showDark?Colors.white:Colors.black),
                    ),
                  );
                },
                separatorBuilder: (context, i) {
                  return Divider(
                    color: Color(Constants.mainColor),
                    height: 2.0,
                  );
                },
                itemCount: listRadioModel.length)
            : Center(child: LoadingShimmer(
          text: "Radio",
        )),
      ),
    );
  }
}
