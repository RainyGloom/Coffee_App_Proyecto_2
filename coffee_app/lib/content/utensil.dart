import 'package:flutter/material.dart';

class Utensil {
  Utensil({required this.name, required this.description});
  final String name;
  String? description;

  static String _pattern = ": ";

  factory Utensil.fromString(String str)
  {
    List<String> part = str.split(_pattern);

    return Utensil(name: part[0], description: part.length == 2 ? part[1] : null);
  }

  Map<String, dynamic> toJson() =>
  {
    'name': name,
    'description': description,
  };

  @override
  String toString()
  {
    String str = name;
    if(description != null && description != "")
    {
      str += _pattern + description!;
    }

    return str;
  }
}