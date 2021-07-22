import 'package:flutter/material.dart';

class Azkar{
  final category;
  final count;
  final description;
  final reference;
  final zekr;
  Azkar({this.category, this.count, this.description, this.reference, this.zekr});
  factory Azkar.fromJSON(Map<String, dynamic> json){
    return Azkar(
      category: json['category'],
      count:json['count'],
      description: json['description'],
      reference:json['reference'],
      zekr:json['zekr']
    );
  }
}