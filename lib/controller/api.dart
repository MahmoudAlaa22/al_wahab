abstract class APIs {
  static const _domain = "https://mp3quran.net";
  static const _path = "$_domain/api";

  //to get arabic
  //type : get
  //params :
  static String get arabic => "$_path/_arabic.json";

  void fun() {}
}
