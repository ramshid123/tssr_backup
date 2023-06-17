import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/study_centre/franchise_view/controller.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/widgets/franchise.dart';
import 'package:tssr_ctrl/widgets/optionsBar_tssr.dart';

class FranchisePage extends GetView<FranchisePageController> {
  const FranchisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      bool isMobile = Get.width <= 768 ? true : false;
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: isMobile ? CustomAppBar('Franchise') : null,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              flexibleSpace: OptionsBar(context, controller,
                  ['Name', 'centre_name', 'Renewal', 'renewal']),
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
                  return Visibility(
                      visible: doc.data()['isAdmin'] == 'true' ? false : true,
                      child: FranchiseCard(doc.data(), controller, context));
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
