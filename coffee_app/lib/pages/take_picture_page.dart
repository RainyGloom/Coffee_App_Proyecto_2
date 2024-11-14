import 'package:coffee_app/pages/common.dart';
import 'package:coffee_app/pages/recipe_create_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:coffee_app/content/recipe.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.recipe,
    required this.camera,
  });

  final CameraDescription camera;
  final Recipe recipe;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and then get the location
            // where the image file is saved.
            final file = await _controller.takePicture();
            final Image image = Image(image: XFileImage(file));
            final String path = (await getApplicationDocumentsDirectory()).path;
            final String name = basename(file.path);
            final String save_path = '$path/$name';
            file.saveTo(save_path);
            widget.recipe.path = save_path;
            goingTo(context, RecipeCreatePage(recipe: widget.recipe, image: image.image,));
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  } 
}