import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:tennisfundacionapp/pages/home/Home.dart';
import 'package:tennisfundacionapp/pages/home/login.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<User?>(context);

    if (user == null) {
      return const Login();
    } else {
      return const Home();
    }
  }
}
