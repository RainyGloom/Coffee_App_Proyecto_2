import 'package:coffee_app/app_data.dart';
import 'package:coffee_app/content/ingredient.dart';
import 'package:coffee_app/content/utensil.dart';
import 'package:coffee_app/pages/common.dart';
import 'package:coffee_app/pages/recipe_info_page.dart';
import 'package:coffee_app/pages/take_picture_page.dart';
import 'package:flutter/material.dart';
import 'package:coffee_app/content/recipe.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class RecipeCreatePage extends StatefulWidget {
  const RecipeCreatePage({super.key, this.recipe, this.image});

  final Recipe? recipe;
  final ImageProvider? image;
  @override
  RCPState createState() => RCPState(); 
  //final Recipe content;
}

class RCPState extends State<RecipeCreatePage>
{
  late Recipe recipe;
  //late ImageProvider image;
  @override
  void initState()
  {
    super.initState();
    recipe = widget.recipe ?? Recipe(title: 'Insertar título', ingredients: [], utensils: [], steps: [], path: defaulImagePath);
    //image = widget.image ?? AssetImage('assets/images/menu/coffee1.jpg');
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
      Stack(
        children: [
          Text("Ingredientes: ", textScaler: TextScaler.linear(1.5), style: textStyle,),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(onPressed: ()
            {
              setState(() => recipe.ingredients.add(Ingredient(name: 'Ingrediente', portion: '0', measure: '-')));
            }, icon: Icon(Icons.add))
          )
        ]
      )
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
    
    utens.add(
      Stack(
        children: [
          Text("Utensilios: ", textScaler: TextScaler.linear(1.5), style: textStyle,),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(onPressed: ()
            {
              setState(() => recipe.utensils.add(Utensil(name: 'Utensilio', description: '')));
            }, icon: Icon(Icons.add))
          )
        ]
      )
    );

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
    stps.add(Stack(
        children: [
          Text("Pasos a seguir: ", textScaler: TextScaler.linear(1.5), style: textStyle,),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(onPressed: ()
            {
              setState(() => recipe.steps.add(' '));
            }, icon: Icon(Icons.add))
          )
        ]
      )
    );
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

    display.add(SizedBox(
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
            List<Recipe> recipes = context.read<AppData>().recipes;
            recipes.add(recipe);
            context.read<AppData>().writeToJson();
            goingTo(context, RecipeInfoPage(image: Image.file(File(recipe.path)).image, index: recipes.length - 1));
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
        child: UnconstrainedBox(
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.file(File(recipe.path)).image,
                )
            ),
            child: 
              TextButton(onPressed: () => goingTo(context, TakePictureScreen(camera: camera, recipe: recipe,)),
              style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states)
                  {
                    if (states.contains(WidgetState.pressed)) {
                      return Theme.of(context).colorScheme.primary.withOpacity(0.05);
                    }
                    return null;
                  },
                ),
              ), 
              child: Text(' '),
            ),
          ),
        ),
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