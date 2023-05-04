import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR%20Page/tssrpage_index.dart';
import 'package:tssr_ctrl/services/database_service.dart';

class TssrPageState {
  var detailsList = [].obs;

  Rx<Query<Map<String, dynamic>>> query =
      DatabaseService.tssrCollection.orderBy('name').where('').obs;
}
