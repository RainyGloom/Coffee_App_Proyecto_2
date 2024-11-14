import 'package:coffee_app/pages/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:coffee_app/content/user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme(),
      home: Scaffold(
        backgroundColor: getBackgroundColor(),
        body: Center(
          child: Column(
            children: 
            [
              Text(' '),
              Icon(Icons.person),
              SizedBox(
                width: double.infinity,
                child: Card(
                  color: getPrimaryColor(),    
                  child: Center(
                    child: Text('\tUsername: ' + currentUser!.name, 
                      textScaler: TextScaler.linear(1.5),
                      style: TextStyle(
                        color: getDarkColor(),
                      ),
                    )
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(    
                  color: getPrimaryColor(),
                  child: Center(
                    child: Text('Email: ' + currentUser!.email, 
                      textScaler: TextScaler.linear(1.5),
                      style: TextStyle(
                        color: getDarkColor(),
                      ),
                    )
                  ),
                ),
              ),
            ]
          ),
        ),
        bottomNavigationBar: createBottomNB(context),
      ),
    );
  }
}