//This class is a general database serivice class
//It will NOT use any other service class, and will NOT have any specific functionality
//It will only have methods that are used to interact with the database
//Methods such as "saveNewPhotoToDB" would not be part of this class as that is NOT a general database service

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DBService{

  FirebaseFirestore db = FirebaseFirestore.instance;


  // will have 5 basic functions:
  // add data to DB
  // update data in DB
  // delete data from DB
  // fetch data from DB
  // confirm existance of data in DB


  /// Checks if a specific document exists in the database.
///
/// This function checks if a specific document exists in a specified path in the database.
/// It requires a path and data as parameters. The data parameter is expected to be the name of the document in the database.
///
/// @param data The name of the document to check for in the database.
/// @param path The path in the database where the document is expected to be.
///
/// @return A Future that completes with a boolean. Returns true if the document exists, false otherwise.
Future<bool> isDataInDB({required data, required String path}) async {
  try {
    // Check if data is not null
    if(data != null) {
      // Fetch the document from the database
      final doc = await getFromDB(path: path, data: data);
      
      // If the document exists, return true
      if(doc != null) {
        return true;
      }
    } else {
      // If data is null, return false
      return false;
    }
  } catch (e) {
    // If an error occurs, print the error if in debug mode and return false
    if(kDebugMode) {
      print(e);
    }
  }
  // If data is not found or an error occurs, return false
  return false;
}

/// Fetches data from the database.
///
/// This function retrieves data from a specified path in the database.
/// It requires a path and data as parameters.
///
/// @param path The path in the database from where data is to be retrieved.
/// @param data The specific document to be retrieved from the database.
///
/// @return A Future that completes with a Map containing the data if it is found,
/// or null if an error occurs or the data is not found.
Future<Map<String, dynamic>?> getFromDB({required String path, required String data}) async {
  try {
    // Fetch the document from the database
    final doc = await db.collection(path).doc(data).get();
    
    // Return the data of the document
    return doc.data();
  } catch (e) {
    // If in debug mode, print the error
    if (kDebugMode) {
      print(e.toString());
    }
  }
  // If an error occurs, return null
  return null;
}


/// Adds an entry to the database.
///
/// This function adds a new document to a specified path in the database.
/// It requires a path, an entry, and data as parameters. The data parameter is expected to be the name of the new document.
///
/// @param path The path in the database where the new document will be added.
/// @param entry The data to be added to the new document. It should be a map where the keys are the field names and the values are the field values.
/// @param data The name of the new document.
///
/// @return A Future that completes with a boolean. Returns true if the document is successfully added, false otherwise.
Future<bool> addEntryToDB({required String path, required Map<String, dynamic> entry, required String data}) async {
  try {
    // Add the new document to the database
    await db.collection(path).doc(data).set(entry);
    // If the document is successfully added, return true
    return true;
  } catch (e) {
    // If an error occurs, print the error if in debug mode
    if (kDebugMode) {
      print(e.toString());
    }
  }
  // If an error occurs, return false
  return false;
}
}

