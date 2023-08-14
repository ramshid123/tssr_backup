import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/_internal/file_picker_web.dart'; // only for web
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/services/pdf_service.dart';
import 'package:tssr_ctrl/services/storage_service.dart';
import 'studentpage_index.dart';

class StudentPageController extends GetxController {
  StudentPageController();
  final state = StudentPageState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    final sf = await SharedPreferences.getInstance();
    state.atc.value = sf.getString(SharedPrefStrings.ATC)!;
    state.query.value =
        DatabaseService.StudentDetailsCollection.orderBy('st_name')
            .where('uploader', isEqualTo: AuthService.auth.currentUser!.uid);

    // ///////////////////////////////////////////

    final userInfo = await DatabaseService.FranchiseCollection.where('atc',
            isEqualTo: state.atc.value)
        .get();
    final List temp_courses = userInfo.docs.first.data()['courses'];

    final courses = temp_courses.map((e) => e.toString()).toList();

    await sf.setStringList(SharedPrefStrings.COURSES, courses);

    state.availableCourses.value = sf
        .getStringList(SharedPrefStrings.COURSES)!
        .map((e) => e.toString())
        .toList();
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

    final dataSnapshot = await DatabaseService.StudentDetailsCollection.where(
            'uploader',
            isEqualTo: AuthService.auth.currentUser!.uid)
        .get();

    final aadhaarListSnapshot = await DatabaseService.MetaInformations.get();
    final List aadhaarList =
        aadhaarListSnapshot.docs.first.data()['aadhaar_list'];

    for (var item in dataSnapshot.docs) {
      if (item.data()['photo_url'] != 'none') {
        await StorageService()
            .instance
            .refFromURL(item.data()['photo_url'])
            .delete();
      }
      if (item.data()['sslc_url'] != 'none') {
        await StorageService()
            .instance
            .refFromURL(item.data()['sslc_url'])
            .delete();
      }
      if (aadhaarList.contains(item.data()['st_aadhaar'])) {
        aadhaarList.remove(item.data()['st_aadhaar']);
        await DatabaseService.MetaInformations.doc(
                aadhaarListSnapshot.docs.first.id)
            .update({
          'aadhaar_list': aadhaarList,
        });
      }
    }

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
      required BuildContext context,
      required String type}) async {
    try {
      FilePickerResult? filePicker;
      PlatformFile file;
      Uint8List fileBytes = Uint8List(0);
      if (kIsWeb) {
        filePicker = await FilePickerWeb.platform.pickFiles(
          allowMultiple: false,
          type: FileType.image,
          dialogTitle: 'Select a photo',
        );
      } else {
        filePicker = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.image,
          dialogTitle: 'Select a photo',
        );
      }
      if (filePicker != null) {
        if (kIsWeb) {
          if (filePicker.files.first.size / 1024 > 500) {
            showSnackBar(
                context: context,
                isError: true,
                title: 'File size exceeded',
                subtitle: 'Upload a photo of maximum 500KB');
            return null;
          }
          file = filePicker.files.first;
          fileBytes = filePicker.files.first.bytes!;
        } else {
          file = filePicker.files.first;
          final compressedFile = await FlutterImageCompress.compressWithFile(
              filePicker.files.first.path!,
              quality: 50);
          fileBytes = compressedFile!;
        }
      }
      if (fileBytes.isEmpty || fileBytes == null) {
        print('photo is null');
        return;
      }
      final ref = await StorageService()
          .instance
          .ref()
          .child(type == 'SSLC' ? 'student_sslc' : 'student_photo')
          .child(state.atc.value)
          .child(reg_no)
          .putData(fileBytes);
      // .putFile(File(imageFile!.files.first.path!));
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
