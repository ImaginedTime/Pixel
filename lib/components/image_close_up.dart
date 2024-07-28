import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageCloseUp extends StatelessWidget {
  const ImageCloseUp({
    super.key,
    required this.image,
    required this.title,
    required this.frameBuilder,
    required this.loadingBuilder,
  });

  final dynamic image;
  final String title;
  final Widget Function(BuildContext, Widget, int?, bool) frameBuilder;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?) loadingBuilder;

  Future<void> _saveImage(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    late String message;

    String dateText = DateTime.now().toString();
    dateText = dateText.substring(0, min(19, dateText.length));

    try {
      final http.Response response =
          await http.get(Uri.parse(image['largeImageURL']));

      // Get temporary directory
      final dir = await getTemporaryDirectory();
      // Create an image name
      var filename = '${dir.path}/SaveImage-$dateText.jpg';
      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);
      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'Image saved to disk';
      }
    } catch (e) {
      message = e.toString();
    }

    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: message == "Image saved to disk"
          ? const Color(0xFF4caf50)
          : const Color(0xFFe91e63),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _saveImage(context);
              },
              icon: const Icon(Icons.download),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Text("Tags:",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ListView.builder(
                itemCount: image['tags'].split(", ").length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    child: Chip(
                      label: Text(image['tags'].split(", ")[index]),
                    ),
                  );
                },
                scrollDirection: Axis.horizontal,
              ),
            ),
            Expanded(
              child: Center(
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 2.5,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Image.network(
                      image['largeImageURL'],
                      fit: BoxFit.cover,
                      frameBuilder: frameBuilder,
                      loadingBuilder: loadingBuilder,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            "Error loading image",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

      //   adding a refresh floating action button
      ),
    );
  }
}
