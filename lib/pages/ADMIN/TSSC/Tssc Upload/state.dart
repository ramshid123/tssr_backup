import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TsscUploadPageState {
  var stepIndex = 0.obs;

  var isLoading = false.obs;

  final formkey = GlobalKey<FormState>();
  final regNo = TextEditingController();
  final name = TextEditingController();
  final skill = TextEditingController();
  final skill_centre = TextEditingController();
  final examDate = TextEditingController();
}
