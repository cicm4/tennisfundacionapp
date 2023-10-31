//This class is used to manage the storage of files using the firestore storage
//It utilizes the firebase_storage package and is only supposed to act generaly
//Methods such as "savePhotoToST" would not be part of this class as that is NOT a general storage service

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class StorageService {
  final st = FirebaseStorage.instance;

  /// Uploads a file to Firebase Storage.
  ///
  /// This function uploads a file to a specified path in Firebase Storage.
  /// It requires a file, a data, and a path as parameters. The data parameter is expected to be the name of the file.
  /// Note that the path parameter is not expected to have a '/' at the end.
  ///
  /// @param file The file to be uploaded.
  /// @param data The name of the file.
  /// @param path The path in Firebase Storage where the file will be uploaded.
  ///
  /// @return A Future that completes with a boolean. Returns true if the file is successfully uploaded, false otherwise.
  Future<bool> addFile(
      {required File file, required String data, required String path}) async {
    try {
      // Create a reference to the file in Firebase Storage
      final fileRef = st.ref().child('$path/$data');
      // Upload the file to Firebase Storage
      await fileRef.putFile(file);
      // If the file is successfully uploaded, return true
      return true;
    } catch (e) {
      // If an error occurs, print the error if in debug mode
      if (kDebugMode) {
        print(e.toString());
      }
    }
    // If an error occurs or the file is not found, return false
    return false;
  }

  /// Checks if a file exists in Firebase Storage.
  ///
  /// This function checks if a file exists at a specified path in Firebase Storage.
  /// It requires a data and a path as parameters. The data parameter is expected to be the name of the file.
  ///
  /// @param data The name of the file.
  /// @param path The path in Firebase Storage where the file is located.
  ///
  /// @return A Future that completes with a boolean. Returns true if the file exists, false otherwise.
  Future<bool> isFileInST({required String data, required String path}) async {
    try {
      final ref = st.ref().child('$path/$data');
      await ref.getDownloadURL();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Deletes a file from Firebase Storage.
  ///
  /// This function deletes a file from a specified path in Firebase Storage.
  /// It requires a data and a path as parameters. The data parameter is expected to be the name of the file.
  ///
  /// @param data The name of the file.
  /// @param path The path in Firebase Storage where the file is located.
  ///
  /// @return A Future that completes when the delete operation is done.
  Future deleteFileFromST({required String data, required String path}) async {
    try {
      final ref = st.ref().child('$path/$data');
      await ref.delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return false;
  }

  /// Retrieves a file from Firebase Storage.
  ///
  /// This function retrieves a file from a specified path in Firebase Storage.
  /// It requires a data and a path as parameters. The data parameter is expected to be the name of the file.
  ///
  /// @param data The name of the file.
  /// @param path The path in Firebase Storage where the file is located.
  ///
  /// @return The reference to the file in Firebase Storage.
  getFileFromST({required String data, required String path}) {
    try {
      final ref = st.ref().child('$path/$data');
      return ref;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }
}
