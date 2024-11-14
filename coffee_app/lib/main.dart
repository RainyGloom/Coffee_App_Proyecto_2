import 'package:coffee_app/app_data.dart';
import 'package:flutter/material.dart';
import 'package:coffee_app/pages/home_page.dart';
import 'package:coffee_app/pages/common.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:coffee_app/content/user.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final cameras = await availableCameras();
  defaulImagePath = (await getApplicationDocumentsDirectory()).path + '/coffee1.jpg';

  File file = File(defaulImagePath);
  final imageBytes = await rootBundle.load('assets/images/menu/coffee1.jpg');
  final buffer = imageBytes.buffer;
  await file.writeAsBytes(
    buffer.asUint8List(imageBytes.offsetInBytes, imageBytes.lengthInBytes));
  // Get a specific camera from the list of available cameras.
  camera = cameras.first;
  runApp(_CoffeeApp());
}

class _CoffeeApp extends StatefulWidget 
{
  @override
  _CoffeeAppState createState() => _CoffeeAppState();
}

class _CoffeeAppState extends State<_CoffeeApp> with WidgetsBindingObserver
{
  late Widget app;
  @override
  void initState() {
    super.initState();
    currentUser = User('Developer', 'Developer@dev.com');
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        break;
      default:
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    AppData data = AppData();
    data.loadFromJson().then((result) => setState(() {}));
    return ChangeNotifierProvider<AppData>(
      create: (context) => data,
      child: MaterialApp(
        home: HomePage(),
      )
    );
  }
}

