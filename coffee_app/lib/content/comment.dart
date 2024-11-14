import 'package:coffee_app/content/ingredient.dart';
import 'package:coffee_app/content/utensil.dart';
import 'package:flutter/material.dart';

class Comment
{
  Comment({required this.rating, required this.content});
  final int rating;
  final String content;

  @override
  String toString()
  {
    return content;
  }
}