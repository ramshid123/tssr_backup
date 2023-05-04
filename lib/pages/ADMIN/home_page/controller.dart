import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage_index.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';

class HomePageController extends GetxController {
  HomePageController();
  final state = HomePageState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    final sf = await SharedPreferences.getInstance();
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
