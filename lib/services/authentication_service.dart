import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tssr_ctrl/routes/names.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';

class AuthService {
  static final auth = FirebaseAuth.instance;

  Future listenForUserChange() async {
    auth.authStateChanges().listen((event) async {
      if (event == null)
        Get.offAllNamed(AppRouteNames.LOGIN);
      else {
        final sf = await SharedPreferences.getInstance();
        final isAdmin = sf.getBool(SharedPrefStrings.ISADMIN);
        if (isAdmin!)
          Get.offAllNamed(AppRouteNames.HOME);//admin
        else
          Get.offAllNamed(AppRouteNames.HOME_FR);//franchise
      }
    });
  }

  Future logout() async {
    try {
      await auth.signOut();
      final SF = await SharedPreferences.getInstance();
      await SF.setString(SharedPrefStrings.EMAIL, '');
      await SF.setString(SharedPrefStrings.PASSWORD, '');
      await SF.setBool(SharedPrefStrings.ISADMIN, false);
      await SF.setString(SharedPrefStrings.CENTRE_HEAD, '');
      await SF.setString(SharedPrefStrings.CENTRE_NAME, '');
      await SF.setString(SharedPrefStrings.ATC, '');
      await SF.setString(SharedPrefStrings.PLACE, '');
      await SF.setString(SharedPrefStrings.DISTRICT, '');
      await SF.setString(SharedPrefStrings.DOC_ID, '');
      await SF.setString(SharedPrefStrings.RENEWAL, '');
    } on FirebaseAuthException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }
}
