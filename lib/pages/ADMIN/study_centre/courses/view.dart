import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/study_centre/courses/controller.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/widgets/optionsBar_tssr.dart';
import 'package:tssr_ctrl/widgets/tssr.dart';

class CoursesPage extends GetView<CoursesController> {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      bool isMobile = Get.width <= 768 ? true : false;
      return Scaffold(
        // appBar: isMobile ? CustomAppBar('Courses') : null,
        appBar: CustomAppBar('Courses'),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await controller.addCourse();
          },
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              flexibleSpace: OptionsBar(context, controller,
                  ['Name', 'course', 'Duration', 'duration']),
              toolbarHeight: 170,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              pinned: false,
              floating: true,
              snap: true,
              stretch: true,
            ),
          ],
          body: Obx(() {
            return Padding(
              padding: isMobile
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(horizontal: Get.width / 20),
              child: FirestoreListView(
                physics: BouncingScrollPhysics(),
                query: controller.state.query.value,
                emptyBuilder: (context) => Center(
                  child: Text(
                    'No Data',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                itemBuilder: (context, doc) {
                  final key = Key(doc.id);
                  return ListTile(
                    title: Text(doc.data()['course']),
                    subtitle: Text(doc.data()['duration']),
                  );
                },
                pageSize: 5,
              ),
            );
          }),
        ),
      );
    });
  }
}
