import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_gallery_ui/image_pick.dart';
import 'package:flutter_gallery_ui/theme/theme.dart';
import 'package:flutter_gallery_ui/ui/image_gallery_page.dart';
import 'package:flutter_gallery_ui/widgets/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<File> _images = [];

  Future<void> _uploadImages() async {
    for (final image in _images) {
      final uri = Uri.parse('http://10.0.2.2:8080/images/upload');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(http.MultipartFile.fromBytes('file', await image.readAsBytes(), filename: 'image.jpg'));

      try {
        final response = await request.send();
        if (response.statusCode == 200) {
          print('Image uploaded successfully');
        } else {
          print('Failed to upload image. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 500,
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Button(
                buttonWidth: 250,
                buttonHeight: 50,
                onPressed: () async {
                  final savedImages = await ImageHelper().pickAndSaveImages(multiple: true);

                  // Update the state with the selected images
                  setState(() {
                    _images = savedImages;
                  });

                  // Upload the selected images to MongoDB
                  await _uploadImages();

                  // Navigate to the gallery page with the list of selected images
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImageGalleryPage(),
                    ),
                  );
                },
                lable: "Add Images",
                backgroundColor: PaletteLightMode.darkBlackColor,
                textColor: PaletteLightMode.whiteColor,
                fontsize: 16,
                fontweight: FontWeight.bold,
              ),
              const SizedBox(
                height: 50,
              ),
              Button(
                buttonWidth: 250,
                buttonHeight: 50,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImageGalleryPage(),
                    ),
                  );
                },
                lable: "View The Gallery",
                backgroundColor: PaletteLightMode.darkBlackColor,
                textColor: PaletteLightMode.whiteColor,
                fontsize: 16,
                fontweight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
