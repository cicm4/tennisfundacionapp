import 'package:flutter/material.dart';

import '../../services/authentication_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
