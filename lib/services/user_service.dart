import 'package:firebase_auth/firebase_auth.dart';

/// `UserService` class.
///
/// This class provides access to the current user and the stream of authentication state changes.
/// It uses Firebase Authentication to manage users.
class UserService {
  /// Stream of authentication state changes.
  ///
  /// This stream emits an event whenever the user signs in or out.
  final userStream = FirebaseAuth.instance.authStateChanges();

  /// Current user instance.
  ///
  /// This is the instance of the currently signed-in user. It is `null` if no user is signed in.
  final user = FirebaseAuth.instance.currentUser;
}