
import 'package:flutter/widgets.dart';

import '../pages/home/Home.dart';
import '../pages/home/login.dart';
import '../pages/home/register.dart';
import '../services/authentication_service.dart';

Map<String, WidgetBuilder> getAppRoutes(AuthService auth) {
  return {
    '/home': (context) => const Home(),
    '/login': (context) => Login(auth: auth),
    '/register': (context) => UserRegister(auth: auth),
  };
}