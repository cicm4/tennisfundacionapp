import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tennisfundacionapp/services/dbService.dart';

/// This class is responsible for handling user authentication using Firebase.
class AuthService {
  // Stream of Firebase User to track user authentication state
  final userStream = FirebaseAuth.instance.authStateChanges();

  // Current user instance
  final user = FirebaseAuth.instance.currentUser;

  /// Sign in with email and password.
  ///
  /// This method attempts to sign in a user using their email and password.
  /// If the user is not found in the database, it adds them.
  ///
  /// @param emailAddress The email address of the user.
  /// @param password The password of the user.
  signInEmailAndPass({required emailAddress, required password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailAddress, password: password);
      if(await _isUserInDB(uid: user!.uid)){
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
  /// This method signs out the current user from the Firebase instance.
  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Add a new user to the database.
  ///
  /// This private method adds a new user to the database with their uid, email, displayName, photoUrl, and type.
  Future<void> _addNewUserToDB() async {
    try{
      String? uid = user!.uid;
      String? email = user!.email;
      String? displayName = user!.displayName;
      String? photoUrl = user!.photoURL;
      String? type = 'donor';

      photoUrl ??= '';

      var newUser = {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'type': type,
      };

      await DBService().addEntryToDB(path: 'users', data: user!.uid, entry: newUser);
    } catch (e) {
      if(kDebugMode) {
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
  Future<bool> _isUserInDB({required String uid}) async {
    try{
      return DBService().isDataInDB(data: uid, path: 'users');
    } catch (e) {
      if(kDebugMode) {
        print(e);
        return false;
      }
    }
    return false;
  }
}