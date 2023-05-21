import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class FranchisePageState {
  Rx<Query<Map<String, dynamic>>> query =
      DatabaseService.tsscCollection.orderBy('name').where('').obs;

  var courseQuery =
      DatabaseService.CourseCollection.orderBy('course').where('course').obs;

  final editFormKey = GlobalKey<FormState>();

  var centre_name = TextEditingController();
  var centre_head = TextEditingController();
  var atc = TextEditingController();
  var district = TextEditingController();
  var place = TextEditingController();
  var renewal = TextEditingController();
  var courses = [].obs;

  var docIdOfFranchise = '';
  var allCourseQuery = DatabaseService.CourseCollection.orderBy('course');
}
