import 'dart:ffi';

import 'package:coffee_app/content/comment.dart';
import 'package:coffee_app/content/ingredient.dart';
import 'package:coffee_app/content/utensil.dart';
import 'package:coffee_app/pages/common.dart';
import 'package:flutter/material.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:json_annotation/json_annotation.dart';

class Recipe
{
  Recipe({required this.title, required this.ingredients, required this.utensils, required this.steps, required this.path});

  late String path;
  //late bool isDefault = false;
  final String title;
  final List<Ingredient> ingredients;
  final List<Utensil> utensils;
  final List<String> steps;

  final List<int> ratings = [];
  final List<Comment> comments = <Comment>[];
  
  factory Recipe.fromJson(Map<String, dynamic> json)
  {
    List<Ingredient> ingredients = (json['ingredients'] as List).map((ingredient)
      {
        return Ingredient(
          name: ingredient['name'], 
          portion: ingredient['portion'], 
          measure: ingredient['measure'],
        );
      },
    ).toList();
    print(ingredients.length);
    List<Utensil> utensils = (json['utensils'] as List).map((utensil)
    {
        return Utensil(
          name: utensil['name'], 
          description: utensil['description']
        );
    }).toList();
    print('d: ' + utensils.length.toString());

    List<String> steps = (json["steps"] as List).map((step)
    {
      return step["step"].toString();
    }).toList();
    print(steps.length);
    return Recipe(
      title: json['title'],
      path: json['image_path'],
      ingredients: ingredients,
      utensils: utensils,
      steps: steps,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'image_path': path,
    'ingredients': ingredients.map((ingredient) => ingredient.toJson()).toList(),
    'utensils': utensils.map((utensils) => utensils.toJson()).toList(),
    'steps': steps.map((step) => {'step': step}).toList(),
  };

  Recipe clone()
  {
    return Recipe(title: title, ingredients: List.from(ingredients), utensils: List.from(utensils), steps: List.from(steps), path: path);
  }

  void addComment(int rating, String comment)
  {
    comments.add(Comment(rating: rating, content: comment)); 
  }

  @override
  String toString() {
    // TODO: implement toString
    String str = "Ingredientes:\n\n";

    for(int i = 0; i < ingredients.length; i++)
    {
      str += (i + 1).toString() + ". " + ingredients[i].toString() + "\n";
    }

    str += "\nUtensilios:\n\n";
    for(int i = 0; i < utensils.length; i++)
    {
      str += (i + 1).toString() + ". " + utensils[i].toString() + "\n";
    }

    str += "\nPasos a seguir:\n\n";

    for(int i = 0; i < steps.length; i++)
    {
      str += (i + 1).toString() + ". " + steps[i] + "\n";
    }
    return title + "\n\n" + str;
  }

}