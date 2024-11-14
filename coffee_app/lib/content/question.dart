import 'package:flutter/material.dart';

class Question 
{
  Question({required this.title, required this.value, required this.max, required this.min});
  String title;
  int value;
  String min;
  String max;

  factory Question.fromJson(Map<String, dynamic> json)
  {
    return Question(title: json['titulo'], value: json['valor'], max: json['max'], min: json['min']);
  }
}