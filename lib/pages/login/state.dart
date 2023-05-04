import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginPageState {
  var email = TextEditingController();
  var password = TextEditingController();
  var formkey = GlobalKey<FormState>();


  var obscurePassword = true.obs;
  var isLoading = false.obs;
}
