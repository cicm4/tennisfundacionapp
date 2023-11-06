import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tennisfundacionapp/services/admin_service.dart';
import 'package:tennisfundacionapp/services/authentication_service.dart';
import 'package:tennisfundacionapp/services/database_service.dart';
import 'package:tennisfundacionapp/services/user_service.dart';

class Home extends StatefulWidget {
  final DBService dbs;
  const Home({super.key, required this.dbs});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAdmin = false;

  @override
  initState() {
    super.initState();
    // Call the checkAdmin function on widget creation
    checkAdmin();
  }

  void checkAdmin() {
    AdminService.isAdmin(
      dbService: widget.dbs, 
      userService: UserService()
    ).then((bool isAdminResult) {
      // Set state is called to rebuild the widget with the updated isAdmin value.
      if (mounted) {
        setState(() {
          isAdmin = isAdminResult;
        });
      }
    }).catchError((error) {
      // Handle any errors here
      if (kDebugMode) {
        print('An error occurred while checking admin status: $error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_print
    print('Home build');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Home'),
            const SizedBox(height: 20),
            Text('$isAdmin'),
            const SizedBox(height: 20), // Add some spacing
            GestureDetector(
              onTap: () {
                // Call your sign-out function here
                signOutUser();
              },
              child: const Text(
                'Sign out',
                style: TextStyle(
                  fontSize: 14, // Making text small
                  color: Colors.blue, // Text color blue
                  decoration: TextDecoration.underline, // Underlined text
                ),
              ),
            ),
            const SizedBox(height: 20), // Add some spacing
            GestureDetector(
              onTap: () {
                // Call your sign-out function here
                Navigator.pushNamed(context, '/images');
              },
              child: const Text(
                'Images',
                style: TextStyle(
                  fontSize: 14, // Making text small
                  color: Colors.blue, // Text color blue
                  decoration: TextDecoration.underline, // Underlined text
                ),
              ),
            ),
            const SizedBox(height: 20), // Add some spacing
            GestureDetector(
              onTap: () {
                // Call your sign-out function here
                Navigator.pushNamed(context, '/donate');
              },
              child: const Text(
                'Donate',
                style: TextStyle(
                  fontSize: 14, // Making text small
                  color: Colors.blue, // Text color blue
                  decoration: TextDecoration.underline, // Underlined text
                ),
              ),
            ),
             if (isAdmin) // This widget will only be added if the user is an admin
              const SizedBox(height: 20),
            if (isAdmin)
              GestureDetector(
                onTap: () {
                  // Actions for admin users
                },
                child: const Text(
                  'Admin Section',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  void signOutUser() {
    // Replace this function with your sign-out logic
    AuthService.signOut();
  }
}
