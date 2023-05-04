import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class FranchiseUploadState {
  final formkey1 = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();

  var courseList = [''];
  var courseLength = 0.obs;

  var currentStep = 0.obs;

  final email = TextEditingController();
  final password = TextEditingController();
  final atc = TextEditingController();
  final centre_head = TextEditingController();
  final centre_name = TextEditingController();
  final district = TextEditingController();
  final place = TextEditingController();
  final renewal = TextEditingController();
}
