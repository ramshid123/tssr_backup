import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class HallTicketPageState {
  Rx<Query<Map<String, dynamic>>> query =
      DatabaseService.hallTKTCollection.orderBy('name').where('').obs;

  final editFormKey = GlobalKey<FormState>();

  var admission_no = TextEditingController();
  var course = TextEditingController();
  var exam_centre = TextEditingController();
  var exam_date = TextEditingController();
  var exam_time = TextEditingController();
  var name = TextEditingController();
  var study_centre = TextEditingController();
}
