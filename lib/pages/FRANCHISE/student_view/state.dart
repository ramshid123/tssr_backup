import 'package:get/get.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentPageState {
  Rx<Query<Map<String, dynamic>>> query =
      DatabaseService.StudentDetailsCollection.orderBy('st_name')
          .where('uploader', isEqualTo: AuthService.auth.currentUser!.uid)
          .obs;
}
