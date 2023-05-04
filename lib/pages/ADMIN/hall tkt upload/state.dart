import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HallTicketUploadState {
  var stepIndex = 0.obs;

  var isLoading = false.obs;

  final formkey = GlobalKey<FormState>();
  final admission_no = TextEditingController();
  final name = TextEditingController();
  final course = TextEditingController();
  final study_centre = TextEditingController();
  final exam_centre = TextEditingController();
  final exam_date = TextEditingController();
  final exam_time = TextEditingController();
}
