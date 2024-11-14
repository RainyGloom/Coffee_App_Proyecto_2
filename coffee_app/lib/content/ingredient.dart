import 'package:coffee_app/content/utensil.dart';
import 'package:flutter/material.dart';

class Ingredient {
  Ingredient({required this.name, required this.portion, required this.measure});
  final String name;
  final String portion;
  final String measure;
  
  static String _pattern1 = ": ";
  static String _pattern2 = " ";

  factory Ingredient.fromString(String str)
  {
    List<String> parts = str.split(_pattern1);

    String name = parts[0];
    String portion = "";
    String measure = "";

    if(parts.length == 2)
    {
      String aux = parts[1];
      parts.remove(aux);
      parts.addAll(aux.split(_pattern2));
      name = parts[0];
      portion = parts[1];
      if(parts.length == 3)
        measure = parts[2];
    }

    return Ingredient(name: name, portion: portion, measure: measure);
  }

  @override
  String toString()
  {
    return name + _pattern1 + portion + _pattern2 + measure.toString();
  }

  factory Ingredient.fromJson(Map<String, dynamic> json)
  {
    return Ingredient(name: json['name'], portion: json['portion'], measure: json['measure']);
  }

  Map<String, dynamic> toJson() =>
  {
    'name': name,
    'portion': portion,
    'measure': measure,
  };
}