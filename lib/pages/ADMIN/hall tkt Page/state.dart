import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class HallTicketPageState{

  Rx<Query<Map<String, dynamic>>> query =
      DatabaseService.hallTKTCollection.orderBy('name').where('').obs;
}
