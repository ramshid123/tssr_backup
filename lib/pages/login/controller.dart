import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:intl/intl.dart';
import 'loginpage_index.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';

class LoginPageController extends GetxController {
  LoginPageController();
  final state = LoginPageState();

  Future login(String email, String password) async {
    if (state.formkey.currentState!.validate()) {
      state.isLoading.value = true;
      final SF = await SharedPreferences.getInstance();
      try {
        final userInfoSnapshot =
            await DatabaseService.FranchiseCollection.where('email',
                    isEqualTo: email.trim())
                .get();
        if (userInfoSnapshot.docs.length == 0) {
          print('no user found');
           Get.showSnackbar(
            GetSnackBar(
              title: 'No user found',
              message:
                  'Please check you email and password',
              backgroundColor: Colors.red,
              duration: 5.seconds,
            ),
          );
          return;
        }
        final userInfo = userInfoSnapshot.docs.single.data();
        final renewalDate = DateFormat("dd/MM/yyyy").parse(userInfo['renewal']);

        final currentDate = DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day);

        if (renewalDate.isAfter(DateTime.now()) || renewalDate == currentDate) {
          await SF.setBool(SharedPrefStrings.ISADMIN,
              userInfo['isAdmin'] == 'true' ? true : false);
          await SF.setString(
              SharedPrefStrings.CENTRE_HEAD, userInfo['centre_head']);
          await SF.setString(
              SharedPrefStrings.CENTRE_NAME, userInfo['centre_name']);
          await SF.setString(SharedPrefStrings.ATC, userInfo['atc']);
          await SF.setString(SharedPrefStrings.PLACE, userInfo['place']);
          await SF.setString(SharedPrefStrings.DISTRICT, userInfo['district']);
          await SF.setString(SharedPrefStrings.DOC_ID, userInfo['doc_id']);
          await SF.setString(SharedPrefStrings.RENEWAL, userInfo['renewal']);

          await SF.setString(SharedPrefStrings.PASSWORD, password.trim());
          await SF.setString(SharedPrefStrings.EMAIL, email.trim());
          await AuthService.auth.signInWithEmailAndPassword(
              email: email.trim(), password: password.trim());
        } else {
          Get.showSnackbar(
            GetSnackBar(
              title: 'Renewal Expreied',
              message:
                  'Your renewal period is expired. Kindly contact the admin.',
              backgroundColor: Colors.red,
              duration: 5.seconds,
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        print(e);
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
        Get.defaultDialog(
            title: e.toString().substring(
                e.toString().indexOf('/') + 1, e.toString().indexOf(']')),
            content: Icon(
              Icons.warning,
              color: Colors.red,
              size: 30,
            ));
      } finally {
        state.isLoading.value = false;
      }
    }
  }
}
