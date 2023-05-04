import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/authentication_service.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'franchiseupload_index.dart';

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
        for (var i in state.courseList) {
          i.length == 0 ? isCompletelyFilled = false : null;
        }
        if (isCompletelyFilled) {
          print('finished');

          await creatingAccountBackend();
        } else {
          print('Error: Not finished completely');
        }
    }
  }

  Future creatingAccountBackend() async {
    try {
      final user = await AuthService.auth.createUserWithEmailAndPassword(
          email: state.email.text.trim(), password: state.password.text.trim());
      print(user.user!.uid);

      final newDoc = DatabaseService.FranchiseCollection.doc();
      await DatabaseService.FranchiseCollection.doc(newDoc.id).set({
        'uploader':AuthService.auth.currentUser!.uid,
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
        'courses': state.courseList,
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
    }
  }
}