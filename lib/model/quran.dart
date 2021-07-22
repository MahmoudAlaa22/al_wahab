import 'dart:developer';

class Quran {
  final List<Surah> surahs;

  Quran({this.surahs});

  factory Quran.fromJSON(Map<String, dynamic> json) {
   final Iterable surahlist = json['data']['surahs'] as Iterable;
    List<Surah> surahsList = surahlist
        .map((i) => Surah.fromJSON(i as Map<String, dynamic>))
        .toList();

    return Quran(surahs: surahsList);
  }
}

class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final List<Ayat> ayahs;

  Surah({
    this.number,
    this.revelationType,
    this.name,
    this.ayahs,
    this.englishName,
    this.englishNameTranslation,
  });

  factory Surah.fromJSON(Map<String, dynamic> json) {
    Iterable ayahs = json['ayahs'] as Iterable;
    List<Ayat> ayahsList = ayahs.map((e) => Ayat.fromJSON(e as Map<String, dynamic>)).toList();

    return Surah(
      name: json['name'] as String,
      number: json['number'] as int,
      englishName: json['englishName'] as String,
      revelationType: json['revelationType'] as String,
      englishNameTranslation: json['englishNameTranslation'] as String,
      ayahs: ayahsList,
    );
  }
}

class Ayat {
  final String text;
  final int number;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final sajda;

  // final String audio;
  // final List<String> audioSecondary;

  Ayat(
      {this.text,
      this.number,
      this.numberInSurah,
      this.juz,
      this.manzil,
      this.page,
      this.ruku,
      this.hizbQuarter,
      this.sajda});

  factory Ayat.fromJSON(Map<String, dynamic> json) {
    return Ayat(
      text: json['text'] as String,
      numberInSurah: json['numberInSurah'] as int,
      number: json['number'] as int,
      hizbQuarter: json['hizbQuarter'] as int,
      juz: json['juz'] as int,
      manzil: json['manzil'] as int,
      page: json['page'] as int,
      ruku: json['ruku'] as int,
      sajda: json['sajda'],
    );
  }
}

class Tafaseer {
  final int id;
  final int sura;
  final int aya;
  final String text;

  Tafaseer({this.id, this.sura, this.aya, this.text});

  factory Tafaseer.fromJSON(Map<String, dynamic> json) {
    return Tafaseer(
        text: json['text'] as String,
        aya: json['aya'] as int,
        id: json['id'] as int,
        sura: json['sura'] as int);
  }
}

class QuranAudio {
  final List<AudioOfSurah> audioOfSurahList;

  QuranAudio({this.audioOfSurahList});

  factory QuranAudio.fromJSON(Map<String, dynamic> json) {
    Iterable reciterslist = json['reciters'] as Iterable;
    List<AudioOfSurah> audioOfSurahList =
        reciterslist.map((e) => AudioOfSurah.fromJSON(e as Map<String, dynamic>)).toList();
    return QuranAudio(audioOfSurahList: audioOfSurahList);
  }
}

class AudioOfSurah {
  final String id;
  final String name;
  final String Server;
  final String rewaya;
  final String count;
  final List suras;

  AudioOfSurah(
      {this.id, this.name, this.Server, this.rewaya, this.count, this.suras});

  factory AudioOfSurah.fromJSON(Map<String, dynamic> json) {
    // log("json['id'] is ${json['id']}");
    return AudioOfSurah(
        id: json['id'] as String,
        name: json['name'] as String,
        count: json['count'] as String,
        rewaya: json['rewaya'] as String,
        Server: json['Server'] as String,
        suras: json['suras'].split(',') as List);
  }
}

class QuranAudioAyah {
  final List<RecitersVerse> listRecitersVerse;

  QuranAudioAyah({this.listRecitersVerse});

  factory QuranAudioAyah.fromJSON(Map<String, dynamic> json) {
    Iterable recitersVerselist = json['reciters_verse'] as Iterable;
    List<RecitersVerse> recitersVerseList =
        recitersVerselist.map((e) => RecitersVerse.fromJSON(e as Map<String, dynamic>)).toList();
    return QuranAudioAyah(listRecitersVerse: recitersVerseList);
  }
}

class RecitersVerse {
  final String id;
  final String name;
  final String rewaya;
  final String musshaf_type;
  final String audio_url_bit_rate_32_;
  final String audio_url_bit_rate_64;
  final String audio_url_bit_rate_128;

  RecitersVerse(
      {this.id,
      this.name,
      this.rewaya,
      this.musshaf_type,
      this.audio_url_bit_rate_32_,
      this.audio_url_bit_rate_64,
      this.audio_url_bit_rate_128});

  factory RecitersVerse.fromJSON(Map<String, dynamic> json) {
    try {
      return RecitersVerse(
          id: json['id'] as String,
          rewaya: json['rewaya'] as String,
          name: json['name'] as String,
          musshaf_type: json['musshaf_type'] as String,
          audio_url_bit_rate_32_: json['audio_url_bit_rate_32_'] as String,
          audio_url_bit_rate_64: json['audio_url_bit_rate_64'] as String,
          audio_url_bit_rate_128: json['audio_url_bit_rate_128'] as String);
    } catch (e) {
      log("sssssssssssssss $e");
      return null;
    }
  }
}
