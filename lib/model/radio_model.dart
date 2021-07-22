import 'dart:developer';

class Radios{
  List<RadioModel>listRadioModel=[];
  factory Radios.fromJSON(Map<String,dynamic>json){
    Iterable radio=json['radios']as Iterable;
    List<RadioModel> list=radio.map((e) => RadioModel.fromJSON(e as Map<String,dynamic>)).toList();
    return Radios(listRadioModel: list);
  }
  Radios({this.listRadioModel});
  }

class RadioModel{
  String name;
  String radio_url;
  factory RadioModel.fromJSON(Map<String,dynamic>json){
    log("JSON['name'] is ${json['name'].toString()}");
    return RadioModel(name:json['name']as String,radio_url: json['radio_url'] as String);
  }
  RadioModel({this.name,this.radio_url});

}