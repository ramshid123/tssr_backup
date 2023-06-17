import 'package:tssr_ctrl/pages/login/loginpage_index.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';

import 'routes/route.dart';
// import 'package:flutter_web_plugins/flutter_web_plugins.dart' as web_plugin; // import for web developement only
import 'routes/names.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'pages/splash_screen/splash_screen.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/pdfTest.dart';
import 'test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // kIsWeb ? web_plugin.setUrlStrategy(web_plugin.PathUrlStrategy()) : null; // function for web only
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
      onReady: () async => await AuthService().listenForUserChange(),
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
