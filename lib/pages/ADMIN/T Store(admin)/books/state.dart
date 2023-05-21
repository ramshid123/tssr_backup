import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class TBooksState {
  Rx<Query<Map<String, dynamic>>> query =
      DatabaseService.StoreCollection.orderBy('name').where('').obs;

  final editFormKey = GlobalKey<FormState>();
  final formkey = GlobalKey<FormState>();
  var course = TextEditingController();
  var desc = TextEditingController();
  var name = TextEditingController();
  var price = TextEditingController();
}
