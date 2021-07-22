import 'dart:convert';

import 'package:al_wahab/model/azkar.dart';

class AzkarApi{
  List<Azkar> azkarParseJson(String response) {
    if (response == null) {
      return [];
    }
    final parsed =
    json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed.map<Azkar>((json) => Azkar.fromJSON(json as Map<String, dynamic>)).toList() as List<Azkar>;
  }
}