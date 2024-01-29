import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_ui/widgets/app_bar.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

class ImageGalleryPage extends StatefulWidget {
  const ImageGalleryPage({Key? key}) : super(key: key);

  @override
  State<ImageGalleryPage> createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  List<Map<String, dynamic>> imageDataList = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIConstants.appBar(
          title: "Gallery",
          fontSize: 25,
          fontWeight: FontWeight.bold,
          titleCenter: true,
        ),
      body: GridView.builder(
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
    );
  }
}
