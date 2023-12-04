// import 'dart:html' as html;   // import only for web

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/_internal/file_picker_web.dart'; // import only for web
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tssr_ctrl/models/student_detail_model.dart';
import 'package:tssr_ctrl/models/time_api_model.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/services/pdf_service.dart';
import 'package:tssr_ctrl/services/storage_service.dart';
import 'studentupload_index.dart';
import 'package:http/http.dart' as http;
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

    final userInfo = await DatabaseService.FranchiseCollection.where('atc',
            isEqualTo: sf.getString(SharedPrefStrings.ATC))
        .get();

    final List temp_courses = userInfo.docs.first.data()['courses'];

    final courses = temp_courses.map((e) => e.toString()).toList();

    await sf.setStringList(SharedPrefStrings.COURSES, courses);

    state.availableCourses.value = sf
        .getStringList(SharedPrefStrings.COURSES)!
        .map((e) => e.toString())
        .toList();
    state.availableCourses.value.insert(0, 'Select course');
    state.st_district.text = 'Select district';
    await getOtherDatasFromEnteredData(false);
  }

  Future selectAndUploadExcel(BuildContext context) async {
    if (state.isTermsAgreed.value) {
      try {
        state.isLoading.value = true;
        final isConnected = await DatabaseService.checkInternetConnection();

        String? excelInString = await ExcelToJson().convert();
        // print(excelInString);

        // return ;
        if (isConnected) {
          final data = StudentDetailModel.fromRawJson(excelInString.toString());

          final sf = await SharedPreferences.getInstance();
          final availableCourss = sf.getStringList(SharedPrefStrings.COURSES);

          final aadhaarListSnapshot =
              await DatabaseService.MetaInformations.get();
          List aadhaarList =
              aadhaarListSnapshot.docs.first.data()['aadhaar_list'];
          aadhaarList = aadhaarList.map((e) => e.toString()).toList();

          for (var item in data.sheet1) {
            if (!availableCourss!.contains(item.course.toUpperCase())) {
              print('Invalid course detected');
              showSnackBar(
                  context: context,
                  isError: true,
                  title: 'Course unavailable',
                  subtitle: 'Unavailable course detected in the given excel.');
              return;
            }
            if (aadhaarList.contains(item.aadhaar.toString())) {
              showSnackBar(
                  context: context,
                  isError: true,
                  title: 'Aadhaar number error',
                  subtitle: 'Aadhaar number in the excel is already taken.');
              return;
            }
          }

          aadhaarList = data.sheet1.map((e) => e.aadhaar.toString()).toList();

          await getOtherDatasFromEnteredData(false);

          int maxSubListSize = 450;

          int lastPart = 101;

          final franchiseDataSnapshot =
              await DatabaseService.FranchiseCollection.where('atc',
                      isEqualTo: state.atc.text)
                  .get();
          int currentRegNo = int.parse(franchiseDataSnapshot.docs.first
              .data()['current_reg_no']
              .toString());

          for (int i = 0; i < data.sheet1.length; i += maxSubListSize) {
            int endIndex = (i + maxSubListSize < data.sheet1.length)
                ? i + maxSubListSize
                : data.sheet1.length;
            List subList = data.sheet1.sublist(i, endIndex);

            final batch = DatabaseService.db.batch();
            for (var item in subList) {
              final reg_no =
                  '${item.name.substring(0, 3).toUpperCase()}\\${decimalToBase36(int.parse(state.atc.text.replaceAll('\\', '').substring(6)))}\\${currentRegNo}';
              // final reg_no2 =
              //     '${state.atc.text.substring(0, 3)}\\${state.atc.text.substring(3)}\\${currentRegNo.toString().substring(0, 3)}\\${currentRegNo.toString().substring(3)}';
              lastPart++;
              DocumentReference newDoc =
                  DatabaseService.StudentDetailsCollection.doc();
              batch.set(newDoc, {
                'uploader': AuthService.auth.currentUser!.uid,
                'doc_id': newDoc.id,
                'st_name': item.name.toUpperCase(),
                'st_dob': item.dob,
                'st_age': item.age,
                'st_gender': item.gender,
                'parent_name': item.parentName.toUpperCase(),
                'st_aadhaar': item.aadhaar,
                'st_address': item.address.toUpperCase(),
                'st_district': item.district.toUpperCase(),
                'st_pincode': item.pincode,
                'st_mobile_no': item.mobileNo,
                'st_email': item.email.toString().toLowerCase(),
                'reg_no': reg_no,
                'study_centre': state.study_centre.text.toUpperCase(),
                'place': state.place.text.toUpperCase(),
                'district': state.district.text.toUpperCase(),
                'course': item.course.toUpperCase(),
                'date_of_admission': item.dateOfAdmission,
                'date_of_course_start': item.courseBatch,
                'photo_url': 'none',
                'sslc_url': 'none',
              });
              currentRegNo++;
            }
            await batch.commit();
          }
          await DatabaseService.FranchiseCollection.doc(
                  franchiseDataSnapshot.docs.first.data()['doc_id'])
              .update({
            'current_reg_no': currentRegNo + 1,
          });
          await DatabaseService.MetaInformations.doc(
                  aadhaarListSnapshot.docs.first.id)
              .update({
            'aadhaar_list': FieldValue.arrayUnion(aadhaarList),
          });
          showSnackBar(
              context: context,
              isError: false,
              title: 'Data uploaded',
              subtitle: 'Data uploaded Successfully.');
          // Get.showSnackbar(GetSnackBar(
          //   title: 'Data uploaded',
          //   message: 'Data uploaded Successfully',
          //   backgroundColor: Colors.green,
          //   duration: 3.seconds,
          // ));
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
        if (e.toString().contains('Null')) {
          Get.defaultDialog(
              title: 'Something gone wrong',
              content: const Icon(
                Icons.warning,
                color: Colors.red,
              ));
          showSnackBar(
              context: context,
              isError: false,
              title: 'Something gone wrong',
              subtitle: '');
        }
      } finally {
        state.isLoading.value = false;
        await clearAllFields();
      }
    } else if (!state.isTermsAgreed.value) {
      Get.showSnackbar(GetSnackBar(
        title: 'Terms and Conditions is not accepted',
        message: 'Please accept Terms and Conditions to continue',
        backgroundColor: Colors.red,
        duration: 2000.milliseconds,
      ));
    }
  }

  Future manualDataSubmit(BuildContext context) async {
    if (state.formkey.currentState!.validate() &&
        state.st_gender.text.isNotEmpty &&
        state.isTermsAgreed.value &&
        state.photo_path.value.name != '' &&
        state.sslc_path.value.name != '' &&
        state.sslc_compressed.value.isNotEmpty &&
        state.photo_compressed.value.isNotEmpty) {
      state.isLoading.value = true;
      try {
        final isConnected = await DatabaseService.checkInternetConnection();
        if (isConnected) {
          await getOtherDatasFromEnteredData(true);

          final aadhaarListSnapshot =
              await DatabaseService.MetaInformations.get();
          final aadhaarList =
              aadhaarListSnapshot.docs.first.data()['aadhaar_list'];

          bool isAadhaarAlreadyRegistered = false;
          if (aadhaarList.contains(state.st_aadhar.text)) {
            isAadhaarAlreadyRegistered = true;
            final studentSnapshot =
                await DatabaseService.StudentDetailsCollection.where(
                        'st_aadhaar',
                        isEqualTo: state.st_aadhar.text)
                    .get();

            if (studentSnapshot.docs.isNotEmpty) {
              for (var student in studentSnapshot.docs) {
                if (student.data()['course'] == state.course.text) {
                  showSnackBar(
                      context: context,
                      isError: true,
                      title: 'Course already added.',
                      subtitle:
                          "The given aadhaar number has already enrolled in this course.");
                  return;
                }
              }
            }

            // showSnackBar(
            //     context: context,
            //     isError: true,
            //     title: 'Aadhaar number is taken.',
            //     subtitle:
            //         "The given aadhaar number is already entered. Please check again.");
            // return;
          }

          final franchiseDataSnapshot =
              await DatabaseService.FranchiseCollection.where('atc',
                      isEqualTo: state.atc.text)
                  .get();
          final currentRegNo = int.parse(franchiseDataSnapshot.docs.first
              .data()['current_reg_no']
              .toString());

          final reg_no =
              '${state.st_name.text.substring(0, 3).toUpperCase()}\\${decimalToBase36(int.parse(state.atc.text.replaceAll('\\', '').substring(6)))}\\${currentRegNo}';
          // final reg_no2 =
          //     '${state.atc.text.substring(0, 3)}\\${state.atc.text.substring(3)}\\${currentRegNo.toString().substring(0, 3)}\\${currentRegNo.toString().substring(3)}';
          TaskSnapshot photo_url;
          TaskSnapshot sslc_url;

          photo_url = await StorageService()
              .instance
              .ref()
              .child('student_photo')
              .child(state.atc.text)
              .child(reg_no)
              .putData(state.photo_compressed.value,
                  SettableMetadata(contentType: 'image/jpeg'));
          sslc_url = await StorageService()
              .instance
              .ref()
              .child('student_sslc')
              .child(state.atc.text)
              .child(reg_no)
              .putData(state.sslc_compressed.value,
                  SettableMetadata(contentType: 'image/jpeg'));

          DocumentReference newDoc =
              DatabaseService.StudentDetailsCollection.doc();

          await DatabaseService.StudentDetailsCollection.doc(newDoc.id).set({
            'uploader': AuthService.auth.currentUser!.uid,
            'doc_id': newDoc.id,
            'st_name': state.st_name.text.toUpperCase(),
            'st_dob': state.st_dob.text,
            'st_age': state.st_age.text,
            'st_gender': state.st_gender.text,
            'parent_name': state.parent_name.text.toUpperCase(),
            'st_aadhaar': state.st_aadhar.text,
            'st_address': state.st_address.text.toUpperCase(),
            'st_district': state.st_district.text.toUpperCase(),
            'st_pincode': state.st_pincode.text,
            'st_mobile_no': state.st_mobile_no.text,
            'st_email': state.st_email.text.toLowerCase(),
            // 'reg_no': state.reg_no.text,
            'reg_no': reg_no,
            'study_centre': state.study_centre.text.toUpperCase(),
            'place': state.place.text.toUpperCase(),
            'district': state.district.text.toUpperCase(),
            'course': state.course.text.toUpperCase(),
            'date_of_admission': state.date_of_admission.text,
            'date_of_course_start': state.date_of_course_start.text,
            'photo_url': await photo_url.ref.getDownloadURL(),
            'sslc_url': await sslc_url.ref.getDownloadURL(),
            // 'duration': state.duration.text,
          }).then((value) async {
            await DatabaseService.FranchiseCollection.doc(
                    franchiseDataSnapshot.docs.first.data()['doc_id'])
                .update({
              'current_reg_no': currentRegNo + 1,
            });
            if (!isAadhaarAlreadyRegistered) {
              await DatabaseService.MetaInformations.doc(
                      aadhaarListSnapshot.docs.first.id)
                  .update({
                'aadhaar_list': FieldValue.arrayUnion([state.st_aadhar.text]),
              });
            }
          }).then((value) {
            clearAllFields();
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
        Get.showSnackbar(GetSnackBar(
          title: 'Error',
          message: 'Something went wrong.',
          backgroundColor: Colors.red,
          duration: 3.seconds,
        ));
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
    } else if (!state.isTermsAgreed.value) {
      Get.showSnackbar(GetSnackBar(
        title: 'Terms and Conditions is not accepted',
        message: 'Please accept Terms and Conditions to continue',
        backgroundColor: Colors.red,
        duration: 2000.milliseconds,
      ));
    } else if (state.photo_path.value.name == '') {
      Get.showSnackbar(GetSnackBar(
        title: 'Photo is required',
        message: 'Please select a photo of the student',
        backgroundColor: Colors.red,
        duration: 2000.milliseconds,
      ));
    } else if (state.sslc_path.value.name == '') {
      Get.showSnackbar(GetSnackBar(
        title: 'SSLC is required',
        message: 'Please select a photo of the SSLC Certificate',
        backgroundColor: Colors.red,
        duration: 2000.milliseconds,
      ));
    } else if (state.sslc_compressed.value.isEmpty ||
        state.photo_compressed.value.isEmpty) {
      Get.showSnackbar(GetSnackBar(
        title: 'files are null',
        message: 'Please select a photo of the SSLC Certificate',
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
    state.atc.text = sf.getString(SharedPrefStrings.ATC)!;
    state.district.text = sf.getString(SharedPrefStrings.DISTRICT)!;
  }

  Future clearAllFields() async {
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
    state.parent_name.clear();
    state.isTermsAgreed.value = false;
    await FilePicker.platform.clearTemporaryFiles();
    Get.back();
  }

  Future<Uint8List?> selectPhoto(
      {required Rx<PlatformFile> file,
      required BuildContext context,
      required Rx<Uint8List> fileBytes}) async {
    FilePickerResult? filePicker;
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
        file.value = filePicker.files.first;
        fileBytes.value = filePicker.files.first.bytes!;
      } else {
        Uint8List? compressedFile;
        file.value = filePicker.files.first;
        compressedFile = await FlutterImageCompress.compressWithFile(
            filePicker.files.first.path!,
            quality: 50);
        fileBytes.value = compressedFile!;
      }
    }
  }
}

String decimalToBase36(int input) {
  final digits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  // DateTime now = DateTime.now();
  // var seconds = now.millisecondsSinceEpoch ~/ 1000;

  String base36Value = '';
  while (input > 0) {
    int remainder = input % 36;
    input = input ~/ 36;
    base36Value = digits[remainder] + base36Value;
  }

  return base36Value;
}
