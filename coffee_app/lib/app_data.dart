import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'content/recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:logger/logger.dart';

class AppData extends ChangeNotifier
{
  AppData() : recipes = [];

  List<Recipe> recipes;

  Future<File> _localFile() async
  {
    final String path = (await getApplicationDocumentsDirectory()).path;
    return File("$path/recipes.json");
  }

  Future<void> loadFromJson() async
  {
    final File file = await _localFile();

    //await file.delete();

    if((await file.exists()))
    {
      final String response = await file.readAsString();
      final List<dynamic> data = json.decode(response);
      recipes = data.map((recipe) => Recipe.fromJson(recipe)).toList();
      Logger().d("Recipes: " + recipes.toString());
    }
    else
    {
      final String response = await rootBundle.loadString('assets/saves/recipes.json');
      final List<dynamic> data = json.decode(response);
      recipes = data.map((recipe) => Recipe.fromJson(recipe)).toList();
      Logger().d("Recipes: " + recipes.toString());
    }
  }

  Future<void> writeToJson() async
  {
    List<dynamic> json = [];

    for(int i = 0; i < recipes.length; i++)
    {
      json.add(recipes[i].toJson());
    }

    File file = await _localFile();

    await file.writeAsString(jsonEncode(json));
  }
}