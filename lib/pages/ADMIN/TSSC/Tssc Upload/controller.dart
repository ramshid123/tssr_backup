import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/models/tssc_model.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'tsscuploadpage_index.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:excel_to_json/excel_to_json.dart';

class TsscUploadPageController extends GetxController {
  TsscUploadPageController();
  final state = TsscUploadPageState();

  Future selectAndUploadExcel() async {
    // print(excelInString);
    try {
      state.isLoading.value = true;
      final isConnected = await DatabaseService.checkInternetConnection();
      if (isConnected) {
        String? excelInString = await ExcelToJson().convert();

        final data = TsscDataModel.fromRawJson(excelInString.toString());

        int maxSubListSize = 450;

        for (int i = 0; i < data.sheet1.length; i += maxSubListSize) {
          int endIndex = (i + maxSubListSize < data.sheet1.length)
              ? i + maxSubListSize
              : data.sheet1.length;
          List subList = data.sheet1.sublist(i, endIndex);

          final batch = DatabaseService.db.batch();
          for (var item in subList) {
            DocumentReference newDoc = DatabaseService.tsscCollection.doc();
            batch.set(newDoc, {
              'doc_id': newDoc.id,
              'reg_no': item.regNo,
              'name': item.name,
              'skill': item.skill,
              'skill_centre': item.skillCentre,
              'exam_date': item.examDate,
            });
          }
          await batch.commit().then((value) => Get.showSnackbar(GetSnackBar(
                title: 'Data uploaded',
                message: 'Data uploaded Successfully',
                backgroundColor: Colors.green,
                duration: 3.seconds,
              )));
        }
      } else {
        Get.showSnackbar(GetSnackBar(
          title: 'Network Error',
          message: 'No stable internet connection detected',
          backgroundColor: Colors.red,
          duration: 3.seconds,
        ));
      }
    } catch (e) {
      printError(info: e.toString());
      if (e.toString().contains('Null')) {
        Get.defaultDialog(
            title: 'Something gone wrong',
            content: const Icon(
              Icons.warning,
              color: Colors.red,
            ));
      }
    } finally {
      state.isLoading.value = false;
    }
  }

  Future manualDataSubmit() async {
    if (state.formkey.currentState!.validate()) {
      state.isLoading.value = true;
      try {
        final isConnected = await DatabaseService.checkInternetConnection();

        if (isConnected) {
          DocumentReference newDoc = DatabaseService.tsscCollection.doc();
          await DatabaseService.tsscCollection.doc(newDoc.id).set({
            'uploader': AuthService.auth.currentUser!.uid,
            'doc_id': newDoc.id,
            'reg_no': state.regNo.text,
            'name': state.name.text,
            'skill': state.skill.text,
            'skill_centre': state.skill_centre.text,
            'exam_date': state.examDate.text,
          }).then((value) {
            state.regNo.clear();
            state.name.clear();
            state.skill.clear();
            state.skill_centre.clear();
            state.examDate.clear();
            Get.showSnackbar(GetSnackBar(
              title: 'Data uploaded',
              message: 'Data uploaded Successfully',
              backgroundColor: Colors.green,
              duration: 3.seconds,
            ));
          });
        } else {
          Get.showSnackbar(GetSnackBar(
            title: 'Network Error',
            message: 'No stable internet connection detected',
            backgroundColor: Colors.red,
            duration: 3.seconds,
          ));
        }
      } catch (e) {
        print(e);
      } finally {
        state.isLoading.value = false;
      }
    }
  }
}
