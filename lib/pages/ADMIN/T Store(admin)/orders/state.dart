import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class TOrdersState {
  Rx<Query<Map<String, dynamic>>> inComingquery =
      DatabaseService.OrderCollection.orderBy('buyer_name').where('').obs;

  Rx<Query<Map<String, dynamic>>> onGoingquery =
      DatabaseService.OrderCollection.orderBy('buyer_name').where('').obs;

  final stepIndex = 0.obs;
}
