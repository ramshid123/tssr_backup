import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'franchiseupload_index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FranchiseUploadController extends GetxController {
  FranchiseUploadController();
  final state = FranchiseUploadState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    state.courseLength.value = state.courseList.length;
  }

  void increamentTextForms() {
    if (state.courseList.last != '') {
      state.courseList.add('');
      state.courseLength.value = state.courseList.length;
      print(state.courseList.length);
    }
  }

  void decreamentTextForms() {
    if (state.courseLength.value > 1) {
      state.courseList.removeLast();
      state.courseLength.value = state.courseList.length;
      print(state.courseList.length);
    }
  }

  void previousButton() {
    state.currentStep.value--;
  }

  Future manualSingleUpload() async {
    switch (state.currentStep.value) {
      case 0:
        if (state.formkey1.currentState!.validate()) {
          print('success');
          state.currentStep.value++;
        }
        break;
      case 1:
        if (state.formkey2.currentState!.validate()) {
          print('success');
          state.currentStep.value++;
        }
        break;
      case 2:
        bool isCompletelyFilled = true;
        isCompletelyFilled =
            state.SelectedCourses.value.length >= 1 ? true : false;
        if (isCompletelyFilled) {
          print('finished');
          await creatingAccountBackend();
        } else if (state.SelectedCourses.value.length == 0) {
          Get.showSnackbar(GetSnackBar(
            title: 'Course not selected',
            message: 'Select atleast one course from the list.',
            backgroundColor: Colors.red,
            duration: 3.seconds,
          ));
        } else {
          Get.showSnackbar(GetSnackBar(
            title: 'Check again!',
            message: 'You left something blank in the form.',
            backgroundColor: Colors.red,
            duration: 3.seconds,
          ));
        }
    }
  }

  Future addCourseToList(String course) async {
    try {
      // state.SelectedCourses.value.add(course);
      if (!state.SelectedCourses.value.contains(course)) {
        state.SelectedCourses.value.add(course);
        update();
      }
      print('done');
    } catch (e) {
      print(e);
    }
  }

  Future removeCourseFromList(String course) async {
    try {
      state.SelectedCourses.value.remove(course);
      update();
      print('done');
    } catch (e) {
      print(e);
    }
  }

  Future searchUsingGivenString(String searchString) async {
    state.allCourseQuery = DatabaseService.CourseCollection.orderBy('course')
        .where('course', isGreaterThanOrEqualTo: '$searchString')
        .where('course', isLessThanOrEqualTo: '$searchString\uf8ff');
    update();
  }

  Future creatingAccountBackend() async {
    try {
      state.isLoading.value = true;
      final isConnected = await DatabaseService.checkInternetConnection();
      if (isConnected) {
        final user = await AuthService.auth.createUserWithEmailAndPassword(
            email: state.email.text.trim(),
            password: state.password.text.trim());
        print(user.user!.uid);

        final newDoc = DatabaseService.FranchiseCollection.doc();
        await DatabaseService.FranchiseCollection.doc(newDoc.id).set({
          'uploader': AuthService.auth.currentUser!.uid,
          'uid': user.user!.uid,
          'doc_id': newDoc.id,
          'email': state.email.text,
          'password': state.password.text,
          'atc': state.atc.value.text,
          'centre_head': state.centre_head.value.text,
          'centre_name': state.centre_name.value.text,
          'district': state.district.value.text,
          'place': state.place.value.text,
          'renewal': state.renewal.value.text,
          'courses': state.SelectedCourses.value,
          'isAdmin': 'false',
        }).then((value) {
          state.email.clear();
          state.password.clear();
          state.atc.clear();
          state.centre_head.clear();
          state.centre_name.clear();
          state.district.clear();
          state.place.clear();
          state.renewal.clear();

          state.courseList = [''];
          state.courseLength.value = 1;
          state.currentStep.value = 0;
          print('done');
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e
          .toString()
          .substring(e.toString().indexOf('/'), e.toString().indexOf(']'))
          .contains('email-already-in-use')) {
        state.currentStep.value = 0;
        Get.snackbar(
          '',
          '',
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(20),
          icon: Icon(
            Icons.warning,
            color: Colors.white,
            size: 30,
          ),
          titleText: Text(
            'Email Already Exists',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          messageText: Text(
            'Please enter a valid email for a new user.',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
      print(e);
    } catch (e) {
      print(e);
    } finally {
      state.isLoading.value = false;
    }
  }
}
