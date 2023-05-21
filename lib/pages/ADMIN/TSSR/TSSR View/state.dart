import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR/TSSR%20View/tssrpage_index.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class TssrPageState {
  var detailsList = [].obs;

  Rx<Query<Map<String, dynamic>>> query =
      DatabaseService.tssrCollection.orderBy('name').where('').obs;

  final editFormKey = GlobalKey<FormState>();

  var name = TextEditingController();
  var reg_no = TextEditingController();
  var result = TextEditingController();
  var course = TextEditingController();
  var duration = TextEditingController();
  var study_centre= TextEditingController();
  var exam_date = TextEditingController();
  var grade = TextEditingController();
}
