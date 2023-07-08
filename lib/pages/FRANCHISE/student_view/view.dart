import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/student_view/controller.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/widgets/optionsBar_tssr.dart';
import 'package:tssr_ctrl/widgets/student_card.dart';

class StudentPage extends GetView<StudentPageController> {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,c) {
        bool isMobile = Get.width<=768?true:false;
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar:CustomAppBar('Student Details'),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                flexibleSpace: OptionsBar(context, controller,
                    ['Name', 'st_name', 'Register No', 'reg_no']),
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
                padding: isMobile?EdgeInsets.zero:EdgeInsets.symmetric(horizontal: Get.width/20),
                child: FirestoreListView(
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
                    return StudentCard(doc.data(), controller, context);
                    // return ListTile();
                  },
                  pageSize: 5,
                ),
              );
            }),
          ),
        );
      }
    );
  }
}
