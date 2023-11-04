import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_index.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';

class ProfileController extends GetxController {
  ProfileController();
  final state = ProfileState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();

    final sf = await SharedPreferences.getInstance();
    state.sharedPrefInstance = sf;
    state.atc.value = await sf.getString(SharedPrefStrings.ATC)!;
    state.centre_head.value =
        await sf.getString(SharedPrefStrings.CENTRE_HEAD)!;
    state.centre_name.value =
        await sf.getString(SharedPrefStrings.CENTRE_NAME)!;
    state.email.value = await sf.getString(SharedPrefStrings.EMAIL)!;
    state.place.value = await sf.getString(SharedPrefStrings.PLACE)!;
    state.district.value = await sf.getString(SharedPrefStrings.DISTRICT)!;
    state.renewal.value = await sf.getString(SharedPrefStrings.RENEWAL)!;
    state.isAdmin.value = await sf.getBool(SharedPrefStrings.ISADMIN)!;
  }
}
