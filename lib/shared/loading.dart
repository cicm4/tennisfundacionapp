//Default basic loading screen for the appimport 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const SpinKitFadingCircle(
        color: Colors.white,
        size: 50.0,
      ),
    );
  }
}
