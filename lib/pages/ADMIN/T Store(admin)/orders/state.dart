import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class TOrdersState{
  Rx<Query<Map<String, dynamic>>> query =
      DatabaseService.OrderCollection.orderBy('buyer_name').where('').obs;
}
