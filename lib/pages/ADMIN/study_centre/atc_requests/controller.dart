import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/routes/names.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'atcrequestspage_index.dart';

class AtcRequestsPageController extends GetxController {
  AtcRequestsPageController();
  final state = AtcRequestsPageState();

  Future deleteRequest({required String docId}) async {
    try {
      await DatabaseService.atcRequestsCollection.doc(docId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future acceptRequest(
      {required QueryDocumentSnapshot<Map<String, dynamic>> doc}) async {
    try {
      await Get.toNamed(AppRouteNames.FRANCHISE_UPLOAD, arguments: doc);
    } catch (e) {
      print(e);
    }
  }
}
