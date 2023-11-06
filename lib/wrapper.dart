import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tennisfundacionapp/pages/home/Home.dart';
import 'package:tennisfundacionapp/pages/home/login.dart';
import 'package:tennisfundacionapp/services/authentication_service.dart';
import 'package:tennisfundacionapp/services/database_service.dart';

class Wrapper extends StatelessWidget {
  final AuthService auth;
  final DBService dbs;
  const Wrapper({super.key, required this.auth, required this.dbs});

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<User?>(context);

    if (user == null) {
      return Login(auth: auth);
    } else {
      return Home(dbs: dbs);
    }
  }
}
