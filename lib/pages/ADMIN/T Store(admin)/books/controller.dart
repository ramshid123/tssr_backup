import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/widgets/tssc.dart';
import 'tbooks_index.dart';

class TBooksController extends GetxController {
  TBooksController();
  final state = TBooksState();

  Future addCourse() async {
    await Get.defaultDialog(
        title: 'Add Course',
        content: Form(
          key: state.formkey,
          child: Column(
            children: [
              CustomTextForm(hintText: 'Book Name', ctrl: state.name),
              SizedBox(height: 20),
              CustomTextForm(hintText: 'Course', ctrl: state.course),
              SizedBox(height: 20),
              CustomTextForm(hintText: 'Description', ctrl: state.desc),
              SizedBox(height: 20),
              CustomTextForm(hintText: 'Price', ctrl: state.price),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  if (state.formkey.currentState!.validate()) {
                    try {
                      final newDoc = DatabaseService.StoreCollection.doc();
                      await DatabaseService.StoreCollection.doc(newDoc.id).set({
                        'doc_id': newDoc.id,
                        'name': state.name.text,
                        'course': state.course.text,
                        'desc': state.desc.text,
                        'price': state.price.text,
                      }).then((value) => Get.back());
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
