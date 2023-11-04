import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileState {
  var atc = ''.obs;
  var centre_head = ''.obs;
  var centre_name = ''.obs;
  var place = ''.obs;
  var district = ''.obs;
  var renewal = ''.obs;
  var email = ''.obs;
  var isAdmin = false.obs;

  SharedPreferences? sharedPrefInstance;
}
