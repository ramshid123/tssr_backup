import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tssr_ctrl/models/student_detail_model.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'studentupload_index.dart';
import 'package:intl/intl.dart';
import 'package:excel_to_json/excel_to_json.dart';

class StudentUploadController extends GetxController {
  StudentUploadController();
  final state = StudentUploadState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    final sf = await SharedPreferences.getInstance();
    state.availableCourses.value = sf
        .getStringList(SharedPrefStrings.COURSES)!
        .map((e) => e.toString())
        .toList();
    state.availableCourses.value.insert(0, 'Select course');
    state.st_district.text = 'Select district';
  }

  Future selectAndUploadExcel() async {
    String? excelInString = await ExcelToJson().convert();
    try {
      state.isLoading.value = true;
      final data = StudentDetailModel.fromRawJson(excelInString.toString());

      await getOtherDatasFromEnteredData(false);

      int maxSubListSize = 450;

      for (int i = 0; i < data.sheet1.length; i += maxSubListSize) {
        int endIndex = (i + maxSubListSize < data.sheet1.length)
            ? i + maxSubListSize
            : data.sheet1.length;
        List subList = data.sheet1.sublist(i, endIndex);

        final batch = DatabaseService.db.batch();
        for (var item in subList) {
          DocumentReference newDoc =
              DatabaseService.StudentDetailsCollection.doc();
          batch.set(newDoc, {
            'uploader': AuthService.auth.currentUser!.uid,
            'doc_id': newDoc.id,
            'st_name': item.name,
            'st_dob': item.dob,
            'st_age': item.age,
            'st_gender': item.gender,
            'st_aadhaar': item.aadhaar,
            'st_address': item.address,
            'st_district': item.district,
            'st_pincode': item.pincode,
            'st_mobile_no': item.mobileNo,
            'st_email': item.email,
            'reg_no': item.regNo,
            'study_centre': state.study_centre.text,
            'place': state.place.text,
            'district': state.district.text,
            'course': item.course,
            'date_of_admission': item.dateOfAdmission,
            'date_of_course_start': item.dateOfCourseStart,
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
      clearAllFields();
    }
  }

  Future manualDataSubmit() async {
    if (state.formkey.currentState!.validate() &&
        state.st_gender.text.isNotEmpty) {
      state.isLoading.value = true;
      try {
        await getOtherDatasFromEnteredData(true);
        DocumentReference newDoc =
            DatabaseService.StudentDetailsCollection.doc();
        await DatabaseService.StudentDetailsCollection.doc(newDoc.id).set({
          'uploader': AuthService.auth.currentUser!.uid,
          'doc_id': newDoc.id,
          'st_name': state.st_name.text,
          'st_dob': state.st_dob.text,
          'st_age': state.st_age.text,
          'st_gender': state.st_gender.text,
          'st_aadhaar': state.st_aadhar.text,
          'st_address': state.st_address.text,
          'st_district': state.st_district.text,
          'st_pincode': state.st_pincode.text,
          'st_mobile_no': state.st_mobile_no.text,
          'st_email': state.st_email.text,
          'reg_no': state.reg_no.text,
          'study_centre': state.study_centre.text,
          'place': state.place.text,
          'district': state.district.text,
          'course': state.course.text,
          'date_of_admission': state.date_of_admission.text,
          'date_of_course_start': state.date_of_course_start.text,
          // 'duration': state.duration.text,
        }).then((value) {
          clearAllFields();
          print('success');
        });
      } catch (e) {
        print(e);
      } finally {
        state.isLoading.value = false;
      }
    } else if (state.st_gender.text.isEmpty) {
      Get.showSnackbar(GetSnackBar(
        title: 'Gender not selected',
        message: 'Please select a gender',
        backgroundColor: Colors.red,
        duration: 2000.milliseconds,
      ));
    }
  }

  Future getOtherDatasFromEnteredData(bool wantToCalculateDOB) async {
    if (wantToCalculateDOB) {
      DateTime dob = DateFormat("dd/MM/yyyy").parse(state.st_dob.text);
      state.st_age.text =
          (DateTime.now().difference(dob).inDays ~/ 365).toString();
    }

    final sf = await SharedPreferences.getInstance();
    state.study_centre.text = sf.getString(SharedPrefStrings.CENTRE_NAME)!;
    state.place.text = sf.getString(SharedPrefStrings.PLACE)!;
    state.district.text = sf.getString(SharedPrefStrings.DISTRICT)!;
  }

  void clearAllFields() {
    state.st_district.text = "Select District";
    state.course.text = "Select Course";
    state.st_name.clear();
    state.st_dob.clear();
    state.st_age.clear();
    state.st_gender.clear();
    state.st_aadhar.clear();
    state.st_address.clear();
    state.st_pincode.clear();
    state.st_mobile_no.clear();
    state.st_email.clear();
    state.reg_no.clear();
    state.study_centre.clear();
    state.place.clear();
    state.district.clear();
    state.date_of_admission.clear();
    state.date_of_course_start.clear();
  }
}
