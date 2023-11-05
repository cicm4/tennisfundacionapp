import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tennisfundacionapp/services/authService.dart';
import 'package:tennisfundacionapp/services/dbService.dart';
import 'package:tennisfundacionapp/services/userService.dart';
import 'package:tennisfundacionapp/shared/routes.dart';
import 'package:tennisfundacionapp/shared/theme.dart';
import 'package:tennisfundacionapp/wrapper.dart';
import 'firebase_options.dart';

//REMEMBER TO GO TO IOS ON https://github.com/miguelpruivo/flutter_file_picker/wiki/Setup#android WHEN YOU ARE READY TO BUILD FOR IOS

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: SafeArea(child: Text('error ${snapshot.error.toString()}')),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // ignore: avoid_print
          print('snapshot.connectionState == ConnectionState.done');
          AuthService auth = AuthService(DBService());
          UserService us = UserService();
          return StreamProvider<User?>.value(
            value: us.userStream,
            initialData: us.user,
            child: MaterialApp(
              routes: getAppRoutes(auth),
              theme: generalTheme,
              home: Wrapper(auth: auth),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Directionality(
            textDirection: TextDirection.ltr, child: Text('loading'));
      },
    );
  }
}
