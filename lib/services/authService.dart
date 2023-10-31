//This class is used only to authenticate the user & save the current user
//It utilizes the firebase_auth package
//It may use methods from the dbService class to create a user in the database
//Thus it may only use the firebase_auth package and dbService to manage users

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:tennisfundacionapp/services/dbService.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();

  final user = FirebaseAuth.instance.currentUser;

  signInEmailAndPass({required emailAddress, required password}) async {
    //singin in and out of app using email and password
    try {
      await FirebaseAuth
          .instance //should work but replace with final credential = await FirebaseAuth.instance if it does not
          .signInWithEmailAndPassword(email: emailAddress, password: password);
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

  signOut() async {
    await FirebaseAuth.instance.signOut();
  }

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