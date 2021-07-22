import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:al_wahab/model/quran.dart';

class QuranApi {
  static List<Surah> parseJson(String response) {
    if (response == null) {
      return [];
    }
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed
        .map<Surah>((json) => Surah.fromJSON(json as Map<String, dynamic>))
        .toList() as List<Surah>;
  }

  List<Tafaseer> tafaseerParseJson(String response) {
    if (response == null) {
      return [];
    }
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed
        .map<Tafaseer>(
            (json) => Tafaseer.fromJSON(json as Map<String, dynamic>))
        .toList() as List<Tafaseer>;
  }

  static Future<QuranAudio> getAudioOfSurah() async {
    String url = "https://mp3quran.net/api/_arabic.json";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return QuranAudio.fromJSON(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception("Failed  to Load AudioOfSurah");
    }
  }


  static Future<QuranAudioAyah> getAudioOfAyah() async {
    String url = "http://api.mp3quran.net/verse/verse_ar.json";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // log("assdsddddddd");
      // log("utf8.decode(response.bodyBytes) is ${utf8.decode(response.bodyBytes)}");
      String json = utf8.decode(response.bodyBytes);
      return QuranAudioAyah.fromJSON(jsonDecode(json) as Map<String, dynamic>);
      // return QuranAudioAyah.fromJSON(jsonDecode(response.body));
    } else {
      throw Exception("Failed  to Load QuranAudioAyah");
    }
  }
}
