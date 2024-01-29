import 'package:flutter_gallery_ui/model/image_model.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<List<ImageModel>> getImages() async {
    final List<XFile>? pickedFiles = await _imagePicker.pickMultiImage();
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      return pickedFiles.map((file) => ImageModel(id: file.path, imageUrl: file.path)).toList();
    } else {
      return [];
    }
  }
}