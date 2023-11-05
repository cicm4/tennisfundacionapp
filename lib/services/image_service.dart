import 'package:tennisfundacionapp/services/database_service.dart';

/// `ImageService` class.
///
/// This class provides a method to retrieve an image URL from the database.
class ImageService{

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
}