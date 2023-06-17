import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class CoursesState {
  Rx<Query<Map<String, dynamic>>> query =
      DatabaseService.tsscCollection.orderBy('name').where('').obs;

  final editFormKey = GlobalKey<FormState>();
  final formkey = GlobalKey<FormState>();
  final courseName = TextEditingController();
  final courseDuration = TextEditingController();

  var isLoading = false.obs;
}
