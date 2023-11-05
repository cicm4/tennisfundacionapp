import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tennisfundacionapp/services/dbService.dart';
import 'package:tennisfundacionapp/services/userService.dart';

/// This class is responsible for handling user authentication using Firebase.
class AuthService {

  ///constructor that passes a database service to limit the number of database service objects
  AuthService(this.dbs);

  // Stream of Firebase User to track user authentication state

  //database service that is used to add new users to firestore
  DBService dbs;
  /// Sign in with email and password.
  ///
  /// This method attempts to sign in a user using their email and password.
  /// If the user is not found in the database, it adds them.
  ///
  /// @param emailAddress The email address of the user.
  /// @param password The password of the user.
  signInEmailAndPass({required emailAddress, required password}) async {
    try {
      UserService us = UserService();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      bool isUserInDB = await _isUserInDB(uid: us.user?.uid);
      if (isUserInDB == false) {
        await _addNewUserToDB();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (kDebugMode) {
          print('No user found for that email.');
        }
      } else if (e.code == 'wrong-password') {
        if (kDebugMode) {
          print('Wrong password provided for that user.');
        }
      }
    }
  }

  /// Sign out the current user.
  ///
  /// This method signs out the current user from the google service.
  /// This method then signs out the current user from the Firebase instance.
  static signOut() async {
    try {
      //sign out of google
      GoogleSignIn().signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    await FirebaseAuth.instance.signOut();
  }

  /// Add a new user to the database.
  ///
  /// This private method adds a new user to the database with their uid, email, displayName, photoUrl, and type.
  Future<void> _addNewUserToDB({String? name}) async {
    try {
      UserService us = UserService();
      String? uid = us.user!.uid;
      String? email = us.user!.email;
      String? displayName = us.user!.displayName;
      String? photoUrl = us.user!.photoURL;
      String? type = 'donor';

      displayName ??= name;

      photoUrl ??= '';

      var newUser = {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'type': type,
      };

      await dbs
          .addEntryToDBWithName(path: 'users', entry: newUser, name: uid);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// Check if a user is in the database.
  ///
  /// This private method checks if a user with a specific uid is in the database.
  ///
  /// @param uid The uid of the user to check.
  ///
  /// @return A Future that completes with a boolean. Returns true if the user is in the database, false otherwise.
  Future<bool> _isUserInDB({String? uid}) async {
    if (uid == null) {
      return false;
    }
    try {
      return dbs.isDataInDB(data: uid, path: 'users');
    } catch (e) {
      if (kDebugMode) {
        print(e);
        return false;
      }
    }
    return false;
  }

  /// Sign in with Google.
  ///
  /// This method initiates the Google sign-in flow and signs in the user into the app using their Google account.
  /// If the user is not found in the database, it adds them.
  ///
  /// @return A Future that completes when the sign-in process is done.
  Future<void> signInWithGoogle() async {
    try {
      // Trigger the Google sign-in flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential using the auth details
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in the user into the app using the credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      UserService us = UserService();

      bool isUserInDB = await _isUserInDB(uid: us.user?.uid);
      // If the user is not found in the database, add them
      if (isUserInDB == false) {
        await _addNewUserToDB();
      }

      return;
    } catch (e) {
      // If an error occurs, print the error if in debug mode
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

/// Register a new user with email and password.
///
/// This method attempts to register a new user using their email and password.
/// If the user is already found in the database, it returns an error message.
///
/// @param emailAddress The email address of the new user.
/// @param password The password of the new user.
/// @param name The name of the new user.
///
/// @return A Future that completes with a String. Returns 'Success' if the user is successfully registered, an error message otherwise.
Future<String> registerWithEmailAndPass(
      {required emailAddress, required password, required name}) async {
    // Register with email and password
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      // Add the new user to the database
      await _addNewUserToDB(name: name);
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth exceptions
      if (e.code == 'weak-password') {
        return 'La contraseña proporcionada es demasiado débil..';
      } else if (e.code == 'email-already-in-use') {
        return 'La cuenta ya existe para ese correo electrónico.';
      } else if (e.code == 'invalid-email') {
        return 'Dirección de correo electrónico no válida';
      } else {
        return 'Error: ${e.toString()}';
      }
    } catch (e) {
      // Handle any other exceptions
      return 'Error: ${e.toString()}';
    }
    // If the user is successfully registered, return 'Success'
    return 'Success';
  }
}
