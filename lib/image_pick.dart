import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageHelper {
  ImageHelper({
    ImagePicker? imagePicker,
  }) : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  Future<List<File>> pickAndSaveImages({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 100,
    bool multiple = false,
  }) async {
    List<File> savedImages = [];

    if (multiple) {
      final pickedFiles = await _imagePicker.pickMultiImage(imageQuality: imageQuality);
      if (pickedFiles != null) {
        for (var file in pickedFiles) {
          savedImages.add(await _saveImage(file));
        }
      }
    } else {
      final pickedFile = await _imagePicker.pickImage(source: source, imageQuality: imageQuality);
      if (pickedFile != null) {
        savedImages.add(await _saveImage(pickedFile));
      }
    }

    return savedImages;
  }

 Future<File> _saveImage(XFile pickedFile) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;

  Directory imagesDirectory = Directory('$appDocPath/assets/images');
  if (!imagesDirectory.existsSync()) {
    imagesDirectory.createSync(recursive: true);
  }

  // Save the image in the 'assets/images' directory
  File savedImage = File('${imagesDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.png');

  await pickedFile.saveTo(savedImage.path);
  return savedImage;
}


}
