import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/my_courses/mycourses_index.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';

class MyCoursesPage extends GetView<MyCoursesController> {
  const MyCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,c) {
        bool isMobile = Get.width<=768?true:false;
        return Scaffold(
            appBar: CustomAppBar('My Courses'),
            body: Obx(
              () => controller.state.atc_code.value.isEmpty
                  ? Center(
                      child: SizedBox(
                        height: Get.width - 100,
                        width: Get.width - 100,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : FirestoreListView(
                      shrinkWrap: true,
                      query: DatabaseService.FranchiseCollection.where('atc',
                          isEqualTo: controller.state.atc_code.value),
                      emptyBuilder: (context) => Center(
                        child: Text(
                          'No Data',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      itemBuilder: (context, doc) => ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Padding(
                          padding:isMobile?
                              EdgeInsets.symmetric(horizontal: 10, vertical: 10):EdgeInsets.symmetric(horizontal: Get.width/5, vertical: 10),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: Text(
                              doc.data()['courses'][index],
                            ),
                            tileColor: ColorConstants.blachish_clr.withOpacity(0.2),
                          ),
                        ),
                        itemCount: doc.data()['courses'].length,
                      ),
                    ),
            ));
      }
    );
  }
}
