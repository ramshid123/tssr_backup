import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/T%20Store(admin)/books/controller.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/widgets/optionsBar_tssr.dart';
import 'package:tssr_ctrl/widgets/t_store_card_admin.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

class TBooksPage extends GetView<TBooksController> {
  const TBooksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      bool isMobile = Get.width <= 768 ? true : false;
      return Scaffold(
        // appBar: isMobile ? CustomAppBar('T Store') : null,
        appBar: CustomAppBar('T Store'),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            await controller.addCourse();
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              flexibleSpace: OptionsBar(
                  context, controller, ['Name', 'name', 'Course', 'course']),
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
            return FirestoreListView(
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
                return TStoreCardAdmin(context, doc.data(), isMobile);
              },
              pageSize: 5,
            );
          }),
        ),
      );
    });
  }
}
