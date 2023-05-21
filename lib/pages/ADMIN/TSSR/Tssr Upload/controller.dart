import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/models/tssr_model.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'tssruploadpage_index.dart';
import 'package:excel_to_json/excel_to_json.dart';

class TssrUploadPageController extends GetxController {
  TssrUploadPageController();
  final state = TssrUploadPageState();

  Future selectAndUploadExcel() async {
    String? excelInString = await ExcelToJson().convert();
    try {
      state.isLoading.value = true;
      final data = TssrDataModel.fromRawJson(excelInString.toString());

      int maxSubListSize = 450;

      for (int i = 0; i < data.sheet1.length; i += maxSubListSize) {
        int endIndex = (i + maxSubListSize < data.sheet1.length)
            ? i + maxSubListSize
            : data.sheet1.length;
        List subList = data.sheet1.sublist(i, endIndex);

        final batch = DatabaseService.db.batch();
        for (var item in subList) {
          DocumentReference newDoc = DatabaseService.tssrCollection.doc();
          batch.set(newDoc, {
            'doc_id': newDoc.id,
            'reg_no': item.registerNo,
            'name': item.name,
            'course': item.course,
            'duration': item.duration,
            'study_centre': item.studyCentre,
            'exam_date': item.examDate,
            'result': item.result,
            'grade': item.grade,
          });
        }
        await batch.commit().then((value) => print('success'));
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
        DocumentReference newDoc = DatabaseService.tssrCollection.doc();
        await DatabaseService.tssrCollection.doc(newDoc.id).set({
          'uploader':AuthService.auth.currentUser!.uid,
          'doc_id': newDoc.id,
          'reg_no': state.regNo.text,
          'name': state.name.text,
          'course': state.course.text,
          'duration': state.duration.text,
          'study_centre': state.studyCentre.text,
          'exam_date': state.examDate.text,
          'result': state.result.text,
          'grade': state.grade.text,
        }).then((value) {
          state.regNo.clear();
          state.name.clear();
          state.course.clear();
          state.duration.clear();
          state.studyCentre.clear();
          state.examDate.clear();
          state.result.clear();
          state.grade.clear();
          print('success');
        });
      } catch (e) {
        print(e);
      } finally {
        state.isLoading.value = false;
      }
    }
  }
}
