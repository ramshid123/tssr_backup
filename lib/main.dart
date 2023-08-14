import 'dart:io';

import 'package:tssr_ctrl/app_update.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';

import 'routes/route.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart'
    as web_plugin; // import for web developement only
import 'routes/names.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

// Please Note: Important
// while running on WEB:
//  -uncommand the import in main.dart
//  -uncommand the setURLStrategy in second line main function
//  -command the appUpdate function in the GetMaterial Widget
//  -uncommand filepickerweb import in Franchise->studentUpload->controller.dart
//  -uncommand the last part of picking files in Franchise->studentUpload->controller.dart
//  -uncommand filepickerweb import in Franchise->studentView->controller.dart
//  -uncommand the filePicker part in Franchise->studentView->controller.dart line:113

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  kIsWeb
      ? web_plugin.setUrlStrategy(web_plugin.PathUrlStrategy())
      : null; // function for web only
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onReady: () async {
        // if (Platform.isAndroid) {
        //   await initPlatformState();   // function for android only
        // }
        await AuthService().listenForUserChange();
      },
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        primarySwatch: Colors.deepPurple,
      ),
      title: 'TASC App',
      // home: SplashScreen(),
      initialRoute: AppRouteNames.SPLASH_SCREEN,
      getPages: AppRoutes.routes,
    );
  }
}
