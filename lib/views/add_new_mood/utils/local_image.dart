import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class LocalImage {
  // Open image gallery and pick an image
  static Future<String?> pickImageFromGallery() async {
    var pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 40);

    // return if user didn't select any
    if (pickedImage == null) {
      return null;
    }

    // crop image after selecting
    var croppedImage = await LocalImage._cropSelectedImage(pickedImage.path);

    // if cancelled by user -> exit
    if (croppedImage == null) {
      return null;
    } else {
      return croppedImage.path;
    }
  }

  static Future<String?> pickImageFromCamera() async {
    var pickedImage = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 70);

    // return if user didn't select any
    if (pickedImage == null) {
      return null;
    }

    // crop image after selecting
    var croppedImage = await LocalImage._cropSelectedImage(pickedImage.path);

    // if cancelled by user -> exit
    if (croppedImage == null) {
      return null;
    } else {
      return croppedImage.path;
    }
  }

  // Crops image
  static Future<CroppedFile?> _cropSelectedImage(String filePath) async {
    return await ImageCropper().cropImage(
        sourcePath: filePath,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        compressQuality: 50,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
          ),
          IOSUiSettings(
            title: 'Crop Image',
          ),
        ]);
  }
}
