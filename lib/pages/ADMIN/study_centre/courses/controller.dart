import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                      final newDoc = DatabaseService.CourseCollection.doc();
                      await DatabaseService.CourseCollection.doc(newDoc.id)
                          .set({
                        'course': state.courseName.text,
                        'duration': state.courseDuration.text,
                        'doc_id': newDoc.id,
                      }).then((value) {
                        Get.back();
                        state.formkey.currentState!.reset();
                      });
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              )
            ],
          ),
        ));
  }
}
