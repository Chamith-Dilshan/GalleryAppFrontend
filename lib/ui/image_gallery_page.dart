import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_ui/constants/icon_constants.dart';
import 'package:flutter_gallery_ui/controller/image_pick.dart';
import 'package:flutter_gallery_ui/theme/theme.dart';
import 'package:flutter_gallery_ui/widgets/app_bar.dart';
import 'package:flutter_svg/svg.dart';
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
  Set<int> selectedIndexes = {};
  bool isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    // Fetch image data from the API when the page is created
    fetchImageData();
  }

  //Fetch images
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

  //Upload images
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

  // Delete selected images
  Future<void> _deleteSelectedImages() async {
    final List<String> imageIdsToDelete = selectedIndexes
        .map((index) => imageDataList[index]['imageId'] as String)
        .toList();

    // Make an API call to delete the selected images
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8080/images/delete'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'imageIds': imageIdsToDelete}),
    );

    if (response.statusCode == 200) {
      print('Selected images deleted successfully');
    } else {
      print(
          'Failed to delete selected images. Status code: ${response.statusCode}');
    }

    // Clear the selected indexes
    setState(() {
      selectedIndexes.clear();
    });
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
        onBackIconButtonpressed: () async {
          final savedImages =
              await ImageHelper().pickAndSaveImages(multiple: true);

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
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                  onLongPress: () {
                    setState(() {
                      isSelectionMode = true;
                      selectedIndexes.add(index);
                    });
                  },
                  onTap: () {
                    // When an image is tapped, open the PhotoView
                    if (isSelectionMode) {
                      setState(() {
                        if (selectedIndexes.contains(index)) {
                          selectedIndexes.remove(index);
                        } else {
                          selectedIndexes.add(index);
                        }
                      });
                    } else {
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
                    }
                  },
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Image.memory(
                        imageDataList[index]['imageData'],
                        fit: BoxFit.cover,
                      ),
                      // Checkbox indicating selection
                      if (isSelectionMode)
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            selectedIndexes.contains(index)
                                ? Icons.check_circle
                                : Icons.circle,
                            color: PaletteLightMode.lightBlackColor,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Bottom button for further actions
          if (isSelectionMode)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                  child: ElevatedButton(
                onPressed: () async {
                  await _deleteSelectedImages();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImageGalleryPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PaletteLightMode.errorColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  minimumSize: const Size(65, 65),
                ),
                child: SvgPicture.asset(IconConstants.deleteIcon),
              )),
            ),
        ],
      ),
    );
  }
}
