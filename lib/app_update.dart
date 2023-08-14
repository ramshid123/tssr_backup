import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_autoupdate/flutter_autoupdate.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';
import 'package:version/version.dart';

// Platform messages are asynchronous, so we initialize in an async method.
Future<void> initPlatformState() async {
  var startTime = DateTime.now().millisecondsSinceEpoch;
  var bytesPerSec = 0;

  // return ;

  final sf = await SharedPreferences.getInstance();
  final version = sf.getString(SharedPrefStrings.VERSION);
  if (version == null) {
    await sf.setString(SharedPrefStrings.VERSION, '1.0.155');
  }

  // return;
  UpdateResult? result;

  var versionUrl =
      'https://firebasestorage.googleapis.com/v0/b/tssr-79f4a.appspot.com/o/_version_management%2Fapp_update_control.json?alt=media&token=af4cb41c-49e5-4b6e-91d3-6207cc5b96f9';

  var manager = UpdateManager(versionUrl: versionUrl);

  try {
    result = await manager.fetchUpdates();
    // return ;
    if (Version.parse(version) < result?.latestVersion) {
      await Get.defaultDialog(
        title: 'Application Update',
        middleText: 'A new version is available',
        onWillPop: () async => false,
        barrierDismissible: false,
        onConfirm: () async {
          var status = await Permission.storage.status;
          while (status.isDenied ||
              status.isPermanentlyDenied ||
              status.isRestricted) {
            await Permission.storage.request();
          }
          Get.defaultDialog(
            title: 'Downloading',
            barrierDismissible: false,
            onWillPop: () async => false,
            content: LinearProgressIndicator(),
          );
          var controller = await result?.initializeUpdate();
          controller?.stream.listen((event) async {
            if (event.completed) {
              await controller.close();
              Get.back();
              await result?.runUpdate(event.path, autoExit: true);
            }
          });
          await sf.setString(
              SharedPrefStrings.VERSION, result!.latestVersion.toString());
        },
        onCancel: () => exit(0),
      );
    }
  } on Exception catch (e) {
    print(e);
    await sf.setString('version', version!);
  }
}
