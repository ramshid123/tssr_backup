import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class FranchiseUploadState {
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
  final city = TextEditingController();
  final pincode = TextEditingController();
  final headPhoneNo = TextEditingController();
  final renewal = TextEditingController();

  var isLoading = false.obs;

  // var docIdOfFranchise = '';
  var allCourseQuery = DatabaseService.CourseCollection.orderBy('course');

  var SelectedCourses = [].obs;
}
