import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageState {
  var atc = ''.obs;
  var centre_head = ''.obs;
  var centre_name = ''.obs;
  var place = ''.obs;
  var email = ''.obs;
  var isAdmin = false.obs;

  SharedPreferences? sharedPrefInstance;

}
