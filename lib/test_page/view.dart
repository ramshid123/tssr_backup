import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/test_page/controller.dart';

class TestPage extends GetView<TestPageController> {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: (Get.height / 2) - 73,
                child: FirestoreListView(
                    loadingBuilder: (context) => FlutterLogo(),
                    pageSize: 5,
                    emptyBuilder: (context) {
                      print('no courses');
                      return Center(
                        child: Text(
                          'No Courses',
                          style: TextStyle(fontSize: 50, color: Colors.black),
                        ),
                      );
                    },
                    query: DatabaseService.FranchiseCollection.where('atc',
                        isEqualTo: 'AB00CDS1'),
                    itemBuilder: (context, doc) => ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = doc.data()['courses'][index];
                            return ListTile(
                              title: Text(item),
                              trailing: IconButton(
                                onPressed: () async =>
                                    controller.removeCourseFromList(item),
                                icon: Icon(Icons.remove_circle),
                              ),
                            );
                          },
                          itemCount: doc.data()['courses'].length,
                        )),
              ),
              Container(
                height: 1,
                width: Get.width,
                color: Colors.black,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search for course..',
                  ),
                  onFieldSubmitted: (val) =>
                      controller.searchUsingGivenString(val),
                ),
              ),
              GetBuilder(
                  init: controller,
                  builder: (ctrl) {
                    return SizedBox(
                      height: (Get.height / 2),
                      child: FirestoreListView(
                        shrinkWrap: true,
                        query: ctrl.state.allCourseQuery,
                        itemBuilder: (context, doc) =>
                            KListViewItemForTest(doc.data()['course'], ctrl),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget KListViewItemForTest(
  String title,
  TestPageController controller,
) {
  return ListTile(
    title: Text(title),
    trailing: IconButton(
      onPressed: () async => controller.addCourseToList(title),
      icon: Icon(Icons.add_circle),
    ),
  );
}
