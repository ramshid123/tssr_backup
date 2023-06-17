import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class ResultViewState {
  Rx<Query<Map<String, dynamic>>> query =
      DatabaseService.ResultCollection.orderBy('name').where('').obs;

  final editFormKey = GlobalKey<FormState>();

  var name = TextEditingController();
  var reg_no = TextEditingController();
  var result = TextEditingController();
  var course = TextEditingController();
  var duration = TextEditingController();
  var study_centre = TextEditingController();
  var exam_centre = TextEditingController();
  var exam_date = TextEditingController();
  var grade = TextEditingController();
}
