import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class TsscPageState {
  var detailsList = [].obs;

  Rx<Query<Map<String, dynamic>>> query =
      DatabaseService.tsscCollection.orderBy('name').where('').obs;

  final editFormKey = GlobalKey<FormState>();

  var name = TextEditingController();
  var reg_no = TextEditingController();
  var skill = TextEditingController();
  var skill_centre = TextEditingController();
  var exam_date = TextEditingController();
}
