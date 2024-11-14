import 'package:camera/camera.dart';
import 'package:coffee_app/pages/questionary.dart';
import 'package:coffee_app/pages/recipe_create_page.dart';
import 'package:flutter/material.dart';
import 'package:coffee_app/pages/home_page.dart';
import 'package:coffee_app/pages/profile_page.dart';
import 'package:coffee_app/content/user.dart';

User? currentUser;
late CameraDescription camera;
late String defaulImagePath;
late int defaultRecipeCount;

Color getPrimaryColor() => Color.fromARGB(255, 249, 242, 232);
Color getSecondColor() => Color.fromARGB(255, 184, 136, 80);
Color getDarkColor() => Color.fromARGB(255, 77, 44, 6);
Color getBackgroundColor() => Color.fromARGB(255, 232, 196, 166);

ThemeData mainTheme()
{
  return ThemeData(
    fontFamily:'seaweed', 
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 21,
          //fontWeight: FontWeight.bold,
      ),
      titleLarge:  TextStyle( 
        fontFamily: 'seaweed',
        fontSize: 21,
          //fontStyle: FontStyle.italic,
      ),
    ),
  );
}

void goingTo(BuildContext context, Widget page)
{
  Navigator.pop(context);
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

BottomNavigationBar createBottomNB(BuildContext context)
{
  return BottomNavigationBar(
    fixedColor: getPrimaryColor(),
    unselectedItemColor: getPrimaryColor(),
    backgroundColor: getDarkColor(),
    items: 
    [
      BottomNavigationBarItem
      (
        icon: ElevatedButton(onPressed: () => goingTo(context, HomePage()), 
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
              (color) => getPrimaryColor()
            )
          ),
          child: Icon(Icons.home, color: getDarkColor())
        ),
        label: 'Home',
      ),
      BottomNavigationBarItem
      (
        icon: ElevatedButton(onPressed: () => goingTo(context, ProfilePage()),
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
              (color) => getPrimaryColor()
            )
          ), 
          child: Icon(Icons.person, color: getDarkColor())
        ),
        label: 'Perfil'
      ),
      BottomNavigationBarItem
      (
        icon: ElevatedButton(onPressed: () => goingTo(context, RecipeCreatePage()),
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
              (color) => getPrimaryColor()
            )
          ), 
          child: Icon(Icons.add, color: getDarkColor())
        ),
        label: 'Añadir'
      ),

      BottomNavigationBarItem
      (
        icon: ElevatedButton(onPressed: () => goingTo(context, Questionary()),
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith(
              (color) => getPrimaryColor()
            )
          ), 
          child: Icon(Icons.question_answer, color: getDarkColor())
        ),
        label: 'Mi opinión'
      ),
    ],
  );
}