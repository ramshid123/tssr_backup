import 'package:tssr_ctrl/pages/login/loginpage_index.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';

import 'routes/route.dart';
import 'routes/names.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      onReady: () async=> await AuthService().listenForUserChange(),
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: AppRouteNames.LOGIN,
      getPages: AppRoutes.routes,
    );
  }
}

