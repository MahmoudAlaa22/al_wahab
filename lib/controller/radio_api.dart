import 'dart:convert';
import 'package:al_wahab/model/radio_model.dart';
import 'package:http/http.dart'as http;

class RadioApi{
  Future<Radios>getAudioOfRadio()async{
    String url="http://api.mp3quran.net/radios/radio_arabic.json";
    final response=await http.get(url);
    if(response.statusCode==200){
      String json=utf8.decode(response.bodyBytes);
      return Radios.fromJSON(jsonDecode(json)as Map<String, dynamic>);
    }
    else{
      throw Exception("Failed  to Load radio");
    }
  }
}