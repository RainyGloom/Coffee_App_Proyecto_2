import 'package:coffee_app/app_data.dart';
import 'package:coffee_app/content/ingredient.dart';
import 'package:coffee_app/content/utensil.dart';
import 'package:coffee_app/pages/common.dart';
import 'package:coffee_app/pages/recipe_info_page.dart';
import 'package:flutter/material.dart';
import 'package:coffee_app/content/recipe.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class RecipeEditPage extends StatefulWidget {
  const RecipeEditPage({super.key, required this.index});
  
  final int index;
  @override
  RIPState createState() => RIPState(); 
  //final Recipe content;
}

class RIPState extends State<RecipeEditPage>
{
  Recipe? recipe;

  @override
  void initState()
  {
    super.initState();
    if(widget.index != -1)
    {
      recipe = context.read<AppData>().recipes[widget.index].clone();
    }
  }

  List<Widget> _buildDisplay(Recipe recipe, BuildContext context)
  {
    void rebuildAllChildren(BuildContext context) {
      void rebuild(Element el) {
        el.markNeedsBuild();
        el.visitChildren(rebuild);
      }
      (context as Element).visitChildren(rebuild);
    }
    String string = "";
    TextStyle textStyle = TextStyle(
      color: getDarkColor(),
      fontSize: 20
    );

    double padding = MediaQuery.of(context).size.width/2 - 100;
    List<Widget> ings =
    [
      //const Text(''),
      Text('Ingredientes: ', textScaler: TextScaler.linear(1.5), style: textStyle)
    ];

    //ings.add(const Text(''));
    for(int i = 0; i < recipe.ingredients.length; i++)
    {
      String index = (i + 1).toString() + ". ";
      ings.add(
        TextFormField(
          initialValue: index + recipe.ingredients[i].toString(), 
          style: textStyle,
          onFieldSubmitted: (value) => recipe.ingredients[i] = Ingredient.fromString(value.replaceAll(index, "")),
        )
      );
    }
    //ings.add(const Text(''));


    List<Widget> display =
    [
      SizedBox(
        width:  double.infinity,
        child: Card(
          color: getPrimaryColor(),
          child: Center(child: TextFormField(initialValue: recipe.title, style: textStyle)),
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: Card(
          color: getPrimaryColor(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: ings),
        ),
      )
    ];

    List<Widget> utens = [];
    
    utens.add(Text("Utensilios: ", textScaler: TextScaler.linear(1.5), style: textStyle,));

    for(int i = 0; i < recipe.utensils.length; i++)
    {
      String index = (i + 1).toString() + ". ";
      utens.add(
        TextFormField(
          initialValue: index + recipe.utensils[i].toString(), 
          style: textStyle,
          onFieldSubmitted: 
          (value) => recipe.utensils[i] = Utensil.fromString(value.replaceAll(index, ""))
        ),
      );
    }

    display.add(SizedBox(
        width: double.infinity,
        child: Card(
          color: getPrimaryColor(),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: utens),
        )
      )
    );

    List<Widget> stps = [];
    stps.add(Text("Pasos a seguir: ", textScaler: TextScaler.linear(1.5), style: textStyle,));
    for(int i = 0; i < recipe.steps.length; i++)
    {
      String index = (i + 1).toString() + ". ";
      stps.add(
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: TextFormField(
            initialValue: index + recipe.steps[i].toString(), 
            style: textStyle,
            onFieldSubmitted: (value) => recipe.steps[i] = value.replaceAll(index, ""),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          )
        )
      );
      stps.add(const Text(''));
    }

    display.add(
      SizedBox(
        width: double.infinity,
        child: Card(
          color: getPrimaryColor(),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: stps),
        )
      )
    );

    display.add(
      Center(
        child: TextButton(
          onPressed: ()
          {
            context.read<AppData>().recipes[widget.index] = recipe;
            goingTo(context, RecipeInfoPage(image: Image.file(File(recipe.path)).image, index: widget.index));
          },
          child: Text('Guardar', style: textStyle),
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith((color) => getSecondColor()),
            foregroundColor: WidgetStateColor.resolveWith((color) => getPrimaryColor())
          ),
        )
      )
    );
    return display;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> recipeWidget = [];
    recipeWidget.add(
      Center(
        child: Image.file(File(recipe!.path)),
      ),
    );
    recipeWidget.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildDisplay(recipe!, context),
      ),
    );
    return MaterialApp(
      theme: mainTheme(),
      home: Scaffold(
        backgroundColor: getBackgroundColor(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: recipeWidget,
          ),
        ),
        bottomNavigationBar: createBottomNB(context),
      ),
    );
  }
}