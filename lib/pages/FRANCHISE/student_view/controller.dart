import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/services/storage_service.dart';
import 'studentpage_index.dart';

class StudentPageController extends GetxController {
  StudentPageController();
  final state = StudentPageState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    state.query.value =
        DatabaseService.StudentDetailsCollection.orderBy('st_name')
            .where('uploader', isEqualTo: AuthService.auth.currentUser!.uid);
  }

  void changeSortOptions(String sortOption) {
    if (sortOption != null) {
      state.query.value = DatabaseService.StudentDetailsCollection.where(
              'uploader',
              isEqualTo: AuthService.auth.currentUser!.uid)
          .orderBy(sortOption);
    }
  }

  void searchByString(String searchString) {
    state.query.value =
        DatabaseService.StudentDetailsCollection.orderBy('st_name')
            .where('uploader', isEqualTo: AuthService.auth.currentUser!.uid)
            .where('st_name', isGreaterThanOrEqualTo: '$searchString')
            .where('st_name', isLessThanOrEqualTo: '$searchString\uf8ff');
    // .where('reg_no', isEqualTo: '$searchString')
    // .where('reg_no', isEqualTo: '$searchString\uf8ff');
  }

  Future deleteAll() async {
    int maxSubListSize = 400;

    final dataSnapshot = await DatabaseService.StudentDetailsCollection.get();

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

  Future selectAndUploadPhoto(
      {required String reg_no,
      required String doc_id,
      required String type}) async {
    try {
      final imageFile = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
        dialogTitle: 'Select a photo',
      );
      final ref = await StorageService()
          .instance
          .ref()
          .child(type == 'SSLC' ? 'student_sslc' : 'student_photo')
          .child(reg_no)
          .putFile(File(imageFile!.files.first.path!));
      DatabaseService.StudentDetailsCollection.doc(doc_id).update({
        type == 'SSLC' ? 'sslc_url' : 'photo_url':
            await ref.ref.getDownloadURL(),
      });
      Get.showSnackbar(GetSnackBar(
        title: 'Photo updated',
        message: 'Photo updated Successfully',
        backgroundColor: Colors.green,
        duration: 5.seconds,
      ));
    } catch (e) {
      print(e);
      Get.showSnackbar(GetSnackBar(
        title: 'Oh Oh!',
        message: 'Something went wrong',
        backgroundColor: Colors.red,
        duration: 5.seconds,
      ));
    }
  }
}
