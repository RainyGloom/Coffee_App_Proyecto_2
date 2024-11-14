import 'package:coffee_app/app_data.dart';
import 'package:coffee_app/pages/common.dart';
import 'package:flutter/material.dart';
import 'package:coffee_app/content/recipe.dart';
import 'package:provider/provider.dart';

class RecipeInfoPage extends StatefulWidget {
  const RecipeInfoPage({super.key, required this.image, required this.index});
  
  final ImageProvider image;
  final int index;
  @override
  RIPState createState() => RIPState(); 
  //final Recipe content;
}

class RIPState extends State<RecipeInfoPage>
{
  Recipe? recipe;

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
      Padding(
        padding: EdgeInsets.only(left: padding + 30),
        child: Text('Ingredientes: ', textScaler: TextScaler.linear(1.5), style: textStyle)
      ),
    ];

    //ings.add(const Text(''));
    for(int i = 0; i < recipe.ingredients.length; i++)
    {
      ings.add(Padding(
          padding: EdgeInsets.only(left: padding),
          child: Text((i + 1).toString() + ". " + recipe.ingredients[i].toString(), style: textStyle,)
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
          child: Center(child: Text(recipe.title, textScaler: TextScaler.linear(2), style: textStyle)),
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
    
    utens.add(Padding(
      padding: EdgeInsets.only(left: padding - 30),
      child: Text("Utensilios: ", textScaler: TextScaler.linear(1.5), style: textStyle,)
      )
    );

    for(int i = 0; i < recipe.utensils.length; i++)
    {
      utens.add(Padding(
        padding: EdgeInsets.only(left: padding),
        child: Text((i + 1).toString() + ". " + recipe.utensils[i].toString(), style: textStyle,)
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
      stps.add(Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text((i + 1).toString() + ". " + recipe.steps[i].toString() + "\n", style: textStyle)
        ),
      );
    }

    display.add(SizedBox(
        width: double.infinity,
        child: Card(
          color: getPrimaryColor(),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: stps),
        )
      )
    );

    InputDecoration deco = InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(202, 212, 142, 49),
          hintText: 'Añadir comentario',
          hoverColor:Color.fromARGB(255, 255, 255, 255),
          contentPadding: const EdgeInsets.only(
            left: 14.0, bottom: 8.0, top: 8.0),
    );

    display.addAll([
      Text("Comentarios: \n", textScaler: TextScaler.linear(2)),
      TextField(style: TextStyle(color:  Color.fromARGB(255, 255, 255, 255)),
        decoration: deco,
        onSubmitted: (value) {
          string = value;
        },
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(onPressed: () 
            { 
              if(string != "")
              {
                recipe.addComment(0, string);
                string = "";
              }

              rebuildAllChildren(context);
            }, 
            child: Text("Subir")
          ),
          ElevatedButton(onPressed: () => {}, child: Text("Cancelar")),
        ],
      ),
    ]);

    for(int i = 0; i < recipe.comments.length; i++)
    {
      display.add(Text((i + 1).toString() + ". " + recipe.comments[i].toString() + "\n"));
    }
    return display;
  }
  
  @override
  Widget build(BuildContext context) {
    recipe = context.read<AppData>().recipes[widget.index];

    List<Widget> recipeWidget = [];
    recipeWidget.add(
      Center(
        child: Image(image: widget.image),
      ),
    );
    recipeWidget.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: recipe != null ? _buildDisplay(recipe!, context) : [],
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