import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tssr_ctrl/app_update.dart';
import 'homefr_index.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';

class HomeFrController extends GetxController {
  HomeFrController();
  final state = HomeFrState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    // if (Platform.isAndroid) {
    //   await initPlatformState();
    // }
    final sf = await SharedPreferences.getInstance();
    state.sharedPrefInstance = sf;
    state.atc.value = await sf.getString(SharedPrefStrings.ATC)!;
    state.centre_head.value =
        await sf.getString(SharedPrefStrings.CENTRE_HEAD)!;
    state.centre_name.value =
        await sf.getString(SharedPrefStrings.CENTRE_NAME)!;
    state.email.value = await sf.getString(SharedPrefStrings.EMAIL)!;
    state.place.value = await sf.getString(SharedPrefStrings.PLACE)!;
    state.isAdmin.value = await sf.getBool(SharedPrefStrings.ISADMIN)!;
  }
}
