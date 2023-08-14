import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentPageState {
  var atc = ''.obs;
  var availableCourses = ['Select course'].obs;

  Rx<Query<Map<String, dynamic>>> query =
      DatabaseService.StudentDetailsCollection.orderBy('st_name')
          .where('uploader', isEqualTo: AuthService.auth.currentUser!.uid)
          .obs;

  final editFormKey = GlobalKey<FormState>();

  var name = TextEditingController();
  var dob = TextEditingController();
  var address = TextEditingController();
  var pincode = TextEditingController();
  var mobile_no = TextEditingController();
  var parent = TextEditingController();
  var email = TextEditingController();
  var course = TextEditingController();
}
