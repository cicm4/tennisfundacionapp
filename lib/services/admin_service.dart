import 'package:tennisfundacionapp/services/database_service.dart';
import 'package:tennisfundacionapp/services/user_service.dart';

/// `AdminService` is a class that provides methods for handling admin-related operations.
///
/// It includes a static method `isAdmin` which checks if a user is an admin.
///
/// The `isAdmin` method takes two parameters:
/// - `userService`: An instance of `UserService` which provides access to the current user.
/// - `dbService`: An instance of `DBService` which provides access to the database.
///
/// The method returns a `Future<bool>` which completes with `true` if the user is an admin, and `false` otherwise.
///
/// Example usage:
/// ```dart
/// bool isAdmin = await AdminService.isAdmin(userService: userService, dbService: dbService);
/// ```
///
/// Note: This class requires instances of `DBService` and `UserService` for its method.
class AdminService{
  /// `isAdmin` is a static method in the `AdminService` class.
  ///
  /// This method checks if a user is an admin by querying the database.
  ///
  /// It takes two parameters:
  /// - `userService`: An instance of `UserService` which provides access to the current user.
  /// - `dbService`: An instance of `DBService` which provides access to the database.
  ///
  /// The method returns a `Future<bool>` which completes with `true` if the user is an admin, and `false` otherwise.
  ///
  /// Example usage:
  /// ```dart
  /// bool isAdmin = await AdminService.isAdmin(userService: userService, dbService: dbService);
  /// ```
  static Future<bool> isAdmin({required UserService userService, required DBService dbService}) async {
    return await dbService.isDataInDB(data: userService.user?.uid, path: 'admin');
  }
}