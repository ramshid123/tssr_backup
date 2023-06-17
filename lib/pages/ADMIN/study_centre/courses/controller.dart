import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/widgets/tssc.dart';
import 'courses_index.dart';

class CoursesController extends GetxController {
  CoursesController();
  final state = CoursesState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    //
    state.query.value =
        DatabaseService.CourseCollection.orderBy('course').where('');
  }

  void changeSortOptions(String sortOption) {
    if (sortOption != null) {
      state.query.value = DatabaseService.CourseCollection.orderBy(sortOption);
    }
  }

  void searchByString(String searchString) {
    state.query.value = DatabaseService.CourseCollection.orderBy('course')
        .where('course', isGreaterThanOrEqualTo: '$searchString')
        .where('course', isLessThanOrEqualTo: '$searchString\uf8ff');
    // .where('reg_no', isEqualTo: '$searchString')
    // .where('reg_no', isEqualTo: '$searchString\uf8ff');
  }

  Future addCourse() async {
    await Get.defaultDialog(
        title: 'Add Course',
        content: Form(
          key: state.formkey,
          child: Column(
            children: [
              CustomTextForm(hintText: 'Course Name', ctrl: state.courseName),
              SizedBox(height: 20),
              CustomTextForm(
                  hintText: 'Course Duration', ctrl: state.courseDuration),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  if (state.formkey.currentState!.validate()) {
                    try {
                      state.isLoading.value = true;
                      final isConnected =
                          await DatabaseService.checkInternetConnection();
                      if (isConnected) {
                        final newDoc = DatabaseService.CourseCollection.doc();
                        await DatabaseService.CourseCollection.doc(newDoc.id)
                            .set({
                          'course': state.courseName.text,
                          'duration': state.courseDuration.text,
                          'doc_id': newDoc.id,
                        }).then((value) {
                          Get.back();
                          state.formkey.currentState!.reset();
                          Get.showSnackbar(GetSnackBar(
                            title: 'Success',
                            message: 'Course added successfully',
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
                        message: 'Something went wrong',
                        backgroundColor: Colors.red,
                        duration: 3.seconds,
                      ));
                    } finally {
                      state.isLoading.value = false;
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                child: Text('Submit'),
              )
            ],
          ),
        ));
  }

  Future deleteAll() async {
    int maxSubListSize = 400;

    final dataSnapshot = await DatabaseService.CourseCollection.get();

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
}
