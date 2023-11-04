import 'dart:io';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tssr_ctrl/app_update.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'homepage_index.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';

class HomePageController extends GetxController {
  HomePageController();
  final state = HomePageState();

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

  // Future createReferenceForAllFranchiseInMetaInfoCollection() async {
  //   final studyCentresSnapshot =
  //       await DatabaseService.FranchiseCollection.get();
  //   final studyCentres =
  //       studyCentresSnapshot.docs.map((e) => e.data()).toList();

  //   final metaList = studyCentres.map((e) => '${e['centre_name']}♪${e['atc']}');

  //   await DatabaseService.MetaInformations.doc('OaATMBOEsv0I9gxXCx9V').update({
  //     'franchises': metaList,
  //   });
  // }
}
