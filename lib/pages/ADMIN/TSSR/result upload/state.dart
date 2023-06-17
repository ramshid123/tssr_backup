import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultUploadState {
  var stepIndex = 0.obs;

  var isLoading = false.obs;

  final formkey = GlobalKey<FormState>();

  final regNo = TextEditingController();
  final name = TextEditingController();
  final course = TextEditingController();
  final duration = TextEditingController();
  final studyCentre = TextEditingController();
  final examCentre = TextEditingController();
  final examDate = TextEditingController();
  final result = TextEditingController();
  final grade = TextEditingController();
}
