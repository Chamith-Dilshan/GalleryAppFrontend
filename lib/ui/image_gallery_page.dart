import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_ui/constants/icon_constants.dart';
import 'package:flutter_gallery_ui/service/image_pick.dart';
import 'package:flutter_gallery_ui/theme/theme.dart';
import 'package:flutter_gallery_ui/widgets/app_bar.dart';
import 'package:flutter_gallery_ui/widgets/button.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

class ImageGalleryPage extends StatefulWidget {
  const ImageGalleryPage({Key? key}) : super(key: key);

  @override
  State<ImageGalleryPage> createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  List<Map<String, dynamic>> imageDataList = [];
  List<File> _images = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch image data from the API when the page is created
    fetchImageData();
  }

  Future<void> fetchImageData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/images'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        imageDataList = data
            .map((item) => {
                  'imageId': item['imageId'].toString(),
                  'imageData': base64Decode(item['imageData']),
                })
            .toList();
      });
    } else {
      // Handle error
      print('Failed to load image data');
    }
  }

  Future<void> _uploadImages() async {
    for (final image in _images) {
      final uri = Uri.parse('http://10.0.2.2:8080/images/upload');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(
          http.MultipartFile.fromBytes('file', await image.readAsBytes(),
              filename: 'image.jpg'),
        );

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
      appBar: UIConstants.appBar(
        title: "Gallery",
        fontSize: 25,
        fontWeight: FontWeight.bold,
        titleCenter: true,
        backIcon: IconConstants.addPlusIcon,
        onBackIconButtonpressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Button(
                      buttonWidth: 100,
                      buttonHeight: 50,
                      onPressed: () async {
                        final savedImages = await ImageHelper()
                            .pickAndSaveImages(multiple: true);

                        // Update the state with the selected images
                        setState(() {
                          _images = savedImages;
                        });

                        // Upload the selected images to MongoDB
                        await _uploadImages();

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
                      fontweight: FontWeight.w500,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      body: SingleChildScrollView(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: imageDataList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // When an image is tapped, open the PhotoView
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoView(
                      imageProvider:
                          MemoryImage(imageDataList[index]['imageData']),
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
              child: Image.memory(
                imageDataList[index]['imageData'],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
