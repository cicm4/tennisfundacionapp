import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:tennisfundacionapp/services/database_service.dart';
import 'package:tennisfundacionapp/services/storage_service.dart';
import 'package:tennisfundacionapp/services/user_service.dart';


/// `ImageService` class.
///
/// This class provides methods to pick an image from the gallery and reduce its quality.
class ImageService{
  double maxHeight;
  double maxWidth;
  int compressionPercent;

  ImageService({required this.maxHeight, required this.maxWidth, required this.compressionPercent});

  /// Checks if a file is an image.
  ///
  /// This method takes a file as a parameter and checks if its extension is one of the common image extensions.
  ///
  /// @param file The file to check.
  ///
  /// @return A boolean indicating whether the file is an image.
  static bool isImage({required File file}) {
    final mimeType = lookupMimeType(file.path);
    if (mimeType == null || !mimeType.startsWith('image')) {
      return false;
    }
    return true;
  }

  /// Picks an image from the gallery.
  ///
  /// This method opens the image picker and allows the user to select an image from the gallery.
  /// It then reduces the quality of the selected image and returns both the original and reduced images.
  ///
  /// @return A Future that completes with a list of two Files: the original image and the reduced image. If the user cancels the picker, it returns null.
  Future<List<File>?> pickImageHD() async {
    XFile? result = await ImagePicker().pickImage(
      maxHeight: maxHeight,
      maxWidth: maxWidth,
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (result != null) {
      File originalImage = File(result.path);
      File reducedImage = await _reduceImageQuality(originalImage, compressionPercent);
      return [originalImage, reducedImage];
    } else {
      // User canceled the picker
      return null;
    }
  }

  /// Reduces the quality of an image.
  ///
  /// This method takes an original image file and a reduction percentage as parameters.
  /// It uses the `compressWithFile` method of `FlutterImageCompress` to reduce the quality of the image.
  ///
  /// @param originalFile The original image file.
  /// @param reductionPercent The percentage by which to reduce the image quality.
  ///
  /// @return A Future that completes with the reduced image file. If the image compression fails, it throws an exception.
  Future<File> _reduceImageQuality(File originalFile, int reductionPercent) async {
    // use a library like flutter_image_compress to reduce image quality
    final bytes = await FlutterImageCompress.compressWithFile(
      originalFile.absolute.path,
      quality: reductionPercent,
    );

    if (bytes != null) {
      final reducedFile = File("${originalFile.path}_reduced");
      await reducedFile.writeAsBytes(bytes);
      return reducedFile;
    } else {
      throw Exception("Image compression failed");
    }
  }

  /// Retrieves an image URL from the database.
  ///
  /// This method takes an image name, a boolean indicating whether the image is low resolution, and a `DBService` instance.
  /// It uses the `getFromDB` method of `DBService` to retrieve the image data from the database, and then extracts the URL from the data.
  ///
  /// @param imageName The name of the image.
  /// @param isLowRes A boolean indicating whether the image is low resolution.
  /// @param dbs A `DBService` instance.
  ///
  /// @return A Future that completes with the image URL. If the URL is not found, it returns an empty string.
  static Future<String> getImageUrl({required String imageName, required bool isLowRes, required DBService dbService}) async {
    // Determine the key to use to extract the URL from the image data
    String urlString;
    if(isLowRes){
      urlString = 'LRURL';
    } else {
      urlString = 'URL';
    }

    // Retrieve the image data from the database
    Map<String, dynamic>? imageData = await dbService.getFromDB(path: 'images', data: imageName);
    // Extract the URL from the imageData map using the 'URL' key
    return imageData?[urlString] as String? ?? '';
  }


  /// Adds a photo to the database.
  ///
  /// This method takes a name, a `UserService` instance, a `DBService` instance, and a `StorageService` instance.
  /// It creates a data map with the image details and uses the `addEntryToDBWithName` method of `DBService` to add the image to the database.
  ///
  /// @param name The name of the image.
  /// @param us A `UserService` instance.
  /// @param dbs A `DBService` instance.
  /// @param st A `StorageService` instance.
  ///
  /// @return A Future that completes with a boolean indicating whether the image was successfully added to the database.
  Future<bool> addPhotoToDB({required String name, required UserService us, required DBService dbs, required StorageService st}) async{
    try {
      String? user = us.user?.displayName;
      user ??= us.user?.email;
      var data = {
        'Name': name,
        'URL': st.getFileFromST(data: name, path: 'Images').getDownloadURL(),
        'LRURL': st.getFileFromST(data: name, path: 'LRImages').getDownloadURL(),
        'Reference': 'Images/$name',
        'User_UID': us.user!.uid,
        'User_Name': us.user!.uid,
        'TimeStamp': DateTime.now(),
      };
      return await dbs.addEntryToDBWithName(path: 'images', entry: data, name: name);
  } catch (e) {
    //print(e.toString()); //if in debug mode
    return false;
  }
}

/// Uploads an image to storage.
  ///
  /// This method takes a name, a list of files, a `StorageService` instance, a `DBService` instance, and a `UserService` instance.
  /// It checks if a file with the same name already exists in storage and if the file is an image.
  /// If the file does not exist and is an image, it uploads the image to storage.
  ///
  /// @param name The name of the image.
  /// @param files A list of files to upload.
  /// @param st A `StorageService` instance.
  /// @param dbs A `DBService` instance.
  /// @param us A `UserService` instance.
  ///
  /// @return A Future that completes with a string indicating whether the image was successfully uploaded to storage.
  Future<String> uploadToStorage(
      {required String name, required List<File> files, required StorageService st, required DBService dbs, required UserService us}) async {
    // Check if a file with the same name already exists
    if (await StorageService().isFileInST(data: name, path: 'Images') &&
        isImage(file: files[0])) {
      return 'File already exists or is not an image';
    }

    // upload high res image
    await StorageService()
        .addFile(file: files[0], data: name, path: 'Images');

    // upload low res image
    await StorageService()
        .addFile(file: files[1], data: name, path: 'LRImages');

    await addPhotoToDB(name: name, us: us, dbs: dbs, st: st);

    return 'File uploaded successfully.';
  }
}