import 'package:flutter/widgets.dart';
import 'package:tennisfundacionapp/services/database_service.dart';
import 'package:tennisfundacionapp/services/storage_service.dart';

import '../pages/home/Home.dart';
import '../pages/home/login.dart';
import '../pages/home/register.dart';
import '../pages/images/images_add.dart';
import '../pages/images/images_home.dart';
import '../pages/images/images_specific.dart';
import '../services/authentication_service.dart';
import '../services/image_service.dart';

Map<String, WidgetBuilder> getAppRoutes(AuthService auth, DBService dbs, StorageService st) {
  return {
    '/home': (context) => const Home(),
    '/login': (context) => Login(auth: auth),
    '/register': (context) => UserRegister(auth: auth),
    '/images': (context) => ImageGaleryHome(dbs: dbs, st: st),
    '/addImage': (context) => AddImagesPage(dbService: dbs, storageService: st),
    '/addFoto': (context) => AddImagesPage(dbService: dbs, storageService: st),
    '/indivFoto': (context) => SpecificImageView(dbService: dbs, imageService: ImageService(compressionPercent: 15, maxHeight: 1920, maxWidth: 1080)),
  };
}