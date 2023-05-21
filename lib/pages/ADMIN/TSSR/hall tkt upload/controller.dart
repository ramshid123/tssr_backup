import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/models/hall_ticket_model.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'hallticketupload_index.dart';
import 'package:excel_to_json/excel_to_json.dart';

class HallTicketUploadController extends GetxController {
  HallTicketUploadController();
  final state = HallTicketUploadState();

  Future selectAndUploadExcel() async {
    String? excelInString = await ExcelToJson().convert();
    // print(excelInString);
    try {
      state.isLoading.value = true;
      final data = HallTicketModel.fromRawJson(excelInString.toString());

      int maxSubListSize = 450;

      for (int i = 0; i < data.sheet1.length; i += maxSubListSize) {
        int endIndex = (i + maxSubListSize < data.sheet1.length)
            ? i + maxSubListSize
            : data.sheet1.length;
        List subList = data.sheet1.sublist(i, endIndex);

        final batch = DatabaseService.db.batch();
        for (var item in subList) {
          DocumentReference newDoc = DatabaseService.hallTKTCollection.doc();
          batch.set(newDoc, {
            'doc_id': newDoc.id,
            'admission_no': item.admissionNo,
            'name': item.name,
            'course': item.course,
            'study_centre': item.studyCentre,
            'exam_centre': item.examCentre,
            'exam_date': item.examDate,
            'exam_time': item.examTime,
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
        DocumentReference newDoc = DatabaseService.hallTKTCollection.doc();
        await DatabaseService.hallTKTCollection.doc(newDoc.id).set({
          'uploader': AuthService.auth.currentUser!.uid,
          'doc_id': newDoc.id,
          'admission_no': state.admission_no.text,
          'name': state.name.text,
          'course': state.course.text,
          'study_centre': state.study_centre.text,
          'exam_centre': state.exam_centre.text,
          'exam_date': state.exam_date.text,
          'exam_time': state.exam_time.text,
        }).then((value) {
          state.admission_no.clear();
          state.name.clear();
          state.course.clear();
          state.study_centre.clear();
          state.exam_centre.clear();
          state.exam_date.clear();
          state.exam_time.clear();
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
