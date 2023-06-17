import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/models/result_mode.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'resultupload_index.dart';
import 'package:excel_to_json/excel_to_json.dart';

class ResultUploadController extends GetxController {
  ResultUploadController();
  final state = ResultUploadState();

  Future selectAndUploadExcel() async {
    try {
      state.isLoading.value = true;
      final isConnected = await DatabaseService.checkInternetConnection();
      if (isConnected) {
        String? excelInString = await ExcelToJson().convert();

        final data = ResultModel.fromRawJson(excelInString.toString());

        int maxSubListSize = 450;

        for (int i = 0; i < data.sheet1.length; i += maxSubListSize) {
          int endIndex = (i + maxSubListSize < data.sheet1.length)
              ? i + maxSubListSize
              : data.sheet1.length;
          List subList = data.sheet1.sublist(i, endIndex);

          final batch = DatabaseService.db.batch();
          for (var item in subList) {
            DocumentReference newDoc = DatabaseService.ResultCollection.doc();
            batch.set(newDoc, {
              'doc_id': newDoc.id,
              'reg_no': item.regNo,
              'name': item.name,
              'course': item.course,
              'study_centre': item.studyCentre,
              'exam_centre': item.examCentre,
              'duration': item.duration,
              'exam_date': item.examDate,
              'grade': item.grade,
              'result': item.result,
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
    state.isLoading.value = true;

    if (state.formkey.currentState!.validate()) {
      try {
        final isConnected = await DatabaseService.checkInternetConnection();
        if (isConnected) {
          DocumentReference newDoc = DatabaseService.ResultCollection.doc();
          await DatabaseService.ResultCollection.doc(newDoc.id).set({
            'uploader': AuthService.auth.currentUser!.uid,
            'doc_id': newDoc.id,
            'reg_no': state.regNo.text,
            'name': state.name.text,
            'course': state.course.text,
            'duration': state.duration.text,
            'study_centre': state.studyCentre.text,
            'exam_centre': state.examCentre.text,
            'exam_date': state.examDate.text,
            'result': state.result.text,
            'grade': state.grade.text,
          }).then((value) {
            state.regNo.clear();
            state.name.clear();
            state.course.clear();
            state.duration.clear();
            state.studyCentre.clear();
            state.examCentre.clear();
            state.examDate.clear();
            state.result.clear();
            state.grade.clear();
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
