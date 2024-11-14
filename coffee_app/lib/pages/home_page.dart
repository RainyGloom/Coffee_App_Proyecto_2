import 'package:coffee_app/app_data.dart';
import 'package:coffee_app/pages/recipe_edit_page.dart';
import 'package:provider/provider.dart';
import 'package:coffee_app/pages/recipe_info_page.dart';
import 'package:flutter/material.dart';
import 'package:coffee_app/pages/common.dart';
import 'package:coffee_app/pages/profile_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math';
import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState(); 
}

class MansoryImage
{
  const MansoryImage({required this.image, required this.width, required this.height});
  final AssetImage image;
  final double width;
  final double height;
}
  
class HomePageState extends State<HomePage>
{
  HomePageState() : images = []
  {
    List<int> indices = [];
    while(images.length < 7)
    {
      int randomHeight = Random().nextInt(6);
      double itemHeight = (randomHeight % 5 + 2) * 100;
      int i = Random().nextInt(7) + 1;
      if(!indices.contains(i))
      {
        indices.add(i);
        images.add(MansoryImage(
          image: AssetImage('assets/images/menu/coffee' + i.toString() + '.jpg'), 
          width: 200, 
          height: itemHeight));
      }
    }
  }

  final List<MansoryImage> images;
  
  List<Widget> _createOptions(BuildContext context)
  {
    return [
      ElevatedButton(onPressed: () => goingTo(context, ProfilePage()),
        style: ButtonStyle(
          backgroundColor: WidgetStateColor.resolveWith(
            (color) => getPrimaryColor()
          ),
        ),
        child: Text('Ver perfil',
          style: TextStyle(
            color: getDarkColor(),
          )
        )
      ),
            ElevatedButton(onPressed: () => goingTo(context, ProfilePage()),
        style: ButtonStyle(
          backgroundColor: WidgetStateColor.resolveWith(
            (color) => getPrimaryColor()
          ),
        ),
        child: Text('Mi opinion',
          style: TextStyle(
            color: getDarkColor(),
          )
        )
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double itemWidth = 200;
    return MaterialApp(
      title: 'Coffee Experience',
      theme: mainTheme(),
      home: Scaffold(
        backgroundColor: getBackgroundColor(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: MasonryGridView.count(
                  itemCount: context.read<AppData>().recipes.length,
                  mainAxisSpacing: 10,
                  crossAxisCount: (width/itemWidth).toInt(),
                  itemBuilder: (context, index) 
                  {
                    ImageProvider asset = Image.file(File(context.read<AppData>().recipes[index].path)).image;
                    return Stack(
                      children:
                      [
                        UnconstrainedBox(
                          child: Container(
                            width: images[index].width,
                            height: images[index].height,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: asset,
                              )
                            ),
                            child: 
                              TextButton(onPressed: () => goingTo(context, RecipeInfoPage(image: asset, index: index,)),
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
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () => goingTo(context, RecipeEditPage(index: index)), 
                            icon: Icon(Icons.edit, color: getBackgroundColor(),)
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () async => await Share.share(context.read<AppData>().recipes[index].toString()), 
                            icon: Icon(Icons.share)
                          )
                        )
                      ],
                    );
                  }
                )
              )
            ]
          ),
        ),
        bottomNavigationBar: createBottomNB(context),
        appBar: AppBar(
          backgroundColor: getDarkColor(),
          leading: Builder(
            builder: (context)
            {
              return IconButton(onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(Icons.menu, color: getPrimaryColor(),),
              );
            },
          ),
        ),
        drawer: Drawer(
          backgroundColor: getDarkColor(),
          child: ListView(
            children: _createOptions(context)
          ),
        ),
      ),
    );
  }
}