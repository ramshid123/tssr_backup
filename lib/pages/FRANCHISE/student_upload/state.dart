import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class StudentUploadState {
  var stepIndex = 0.obs;

  var isLoading = false.obs;

  var isTermsAgreed = false.obs;

  List<String> districts = [
    'Select district',
    'Thiruvananthapuram',
    'Kollam',
    'Pathanamthitta',
    'Alappuzha',
    'Kottayam',
    'Idukki',
    'Ernakulam',
    'Thrissur',
    'Palakkad',
    'Malappuram',
    'Kozhikode',
    'Wayanad',
    'Kannur',
    'Kasaragod',
  ];

  var availableCourses = ['Select course'].obs;
  var batches = ["June batch", "November batch"].obs;

  final formkey = GlobalKey<FormState>();
  final st_name = TextEditingController();
  final st_dob = TextEditingController();
  final st_age = TextEditingController();
  final st_gender = TextEditingController();
  final parent_name = TextEditingController();
  final st_aadhar = TextEditingController();
  final st_address = TextEditingController();
  final st_district = TextEditingController();
  final st_pincode = TextEditingController();
  final st_mobile_no = TextEditingController();
  final st_email = TextEditingController();
  final reg_no = TextEditingController();
  final study_centre = TextEditingController();
  final atc = TextEditingController();
  final place = TextEditingController();
  final district = TextEditingController();
  final course = TextEditingController();
  final date_of_admission = TextEditingController();
  final date_of_course_start = TextEditingController(text: "June batch");

  var sslc_path = PlatformFile(name: '', size: 0).obs;
  var photo_path = PlatformFile(name: '', size: 0).obs;

  Rx<Uint8List> sslc_compressed = Uint8List(0).obs;
  Rx<Uint8List> photo_compressed = Uint8List(0).obs;
  // final district = TextEditingController(); higher education qualification
  // final district = TextEditingController(); technical professionnal qualification
  // final duration = TextEditingController();
}
