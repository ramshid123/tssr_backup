import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/widgets/tssc.dart';
import 'tbooks_index.dart';

class TBooksController extends GetxController {
  TBooksController();
  final state = TBooksState();

  void changeSortOptions(String sortOption) {
    if (sortOption != null) {
      state.query.value = DatabaseService.StoreCollection.orderBy(sortOption);
    }
  }

  void searchByString(String searchString) {
    state.query.value = DatabaseService.StoreCollection
        .orderBy('name')
        .where('name', isGreaterThanOrEqualTo: '$searchString')
        .where('name', isLessThanOrEqualTo: '$searchString\uf8ff');
    // .where('reg_no', isEqualTo: '$searchString')
    // .where('reg_no', isEqualTo: '$searchString\uf8ff');
  }

  Future addCourse() async {
    await Get.defaultDialog(
        title: 'Add Course',
        content: Form(
          key: state.formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      state.isLoading.value = true;
                      final isConnected =
                          await DatabaseService.checkInternetConnection();
                      if (isConnected) {
                        final newDoc = DatabaseService.StoreCollection.doc();
                        await DatabaseService.StoreCollection.doc(newDoc.id)
                            .set({
                          'doc_id': newDoc.id,
                          'name': state.name.text,
                          'course': state.course.text,
                          'desc': state.desc.text,
                          'price': state.price.text,
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

    final dataSnapshot = await DatabaseService.StoreCollection.get();

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
