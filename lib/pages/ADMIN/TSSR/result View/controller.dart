import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'resultview_index.dart';

class ResultViewController extends GetxController {
  ResultViewController();
  final state = ResultViewState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    //
    state.query.value =
        DatabaseService.ResultCollection.orderBy('name').where('');
    // update();
  }

  void changeSortOptions(String sortOption) {
    if (sortOption != null) {
      state.query.value = DatabaseService.ResultCollection.orderBy(sortOption);
    }
  }

  void searchByString(String searchString) {
    state.query.value = DatabaseService.ResultCollection
        .orderBy('name')
        .where('name', isGreaterThanOrEqualTo: '$searchString')
        .where('name', isLessThanOrEqualTo: '$searchString\uf8ff');
    // .where('reg_no', isEqualTo: '$searchString')
    // .where('reg_no', isEqualTo: '$searchString\uf8ff');
  }

    Future deleteAll() async {
    int maxSubListSize = 400;

    final dataSnapshot = await DatabaseService.ResultCollection.get();

    for (int i = 0; i < dataSnapshot.docs.length; i += maxSubListSize) {
      int endIndex = (i + maxSubListSize < dataSnapshot.docs.length)
          ? i + maxSubListSize
          : dataSnapshot.docs.length;
      List<QueryDocumentSnapshot<Map<String, dynamic>>> subList =
          dataSnapshot.docs.sublist(i, endIndex);

      final batch = DatabaseService.db.batch();

      for (int i = 0; i < subList.length; i++) {
        batch.delete(subList[i].reference);
      }
      await batch.commit();
    }
    Get.showSnackbar(GetSnackBar(
      title: 'Deleted',
      message: 'All Data Deleted',
      backgroundColor: Colors.green,
      duration: 5.seconds,
    ));
  }

}
