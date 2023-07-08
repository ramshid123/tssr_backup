import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class NotificationsAdminState {
  Rx<Query<Map<String, dynamic>>> query =
      DatabaseService.Notifications.orderBy('time_lapse',descending: true).obs;

  var titleCont = TextEditingController();
  var messageCont = TextEditingController();

  final formKey = GlobalKey<FormState>();
}
