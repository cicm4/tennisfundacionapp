import 'package:flutter/widgets.dart';
import 'package:tennisfundacionapp/services/database_service.dart';

import '../pages/home/Home.dart';
import '../pages/home/login.dart';
import '../pages/home/register.dart';
import '../pages/images/images_home.dart';
import '../services/authentication_service.dart';

Map<String, WidgetBuilder> getAppRoutes(AuthService auth, DBService dbs) {
  return {
    '/home': (context) => const Home(),
    '/login': (context) => Login(auth: auth),
    '/register': (context) => UserRegister(auth: auth),
    '/images': (context) => ImageGaleryHome(dbs: dbs),
  };
}