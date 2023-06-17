import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';
import 'mycourses_index.dart';

class MyCoursesController extends GetxController {
  MyCoursesController();
  final state = MyCoursesState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    state.isLoading.value = true;
    final sf = await SharedPreferences.getInstance();
    state.atc_code.value = sf.getString(SharedPrefStrings.ATC).toString();
    state.isLoading.value = false;
  }
}
