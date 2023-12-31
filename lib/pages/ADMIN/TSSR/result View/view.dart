import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR/result%20View/controller.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/widgets/optionsBar_tssr.dart';
import 'package:tssr_ctrl/widgets/result.dart';

class ResultViewPage extends GetView<ResultViewController> {
  const ResultViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      // bool isMobile = Get.width<=768?true:false;
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar('TSSR'),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              flexibleSpace: OptionsBar(context, controller,
                  ['Name', 'name', 'Register No', 'reg_no']),
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
              // padding: isMobile
              //     ? EdgeInsets.zero
              //     : EdgeInsets.symmetric(horizontal: Get.width / 20),
              padding: EdgeInsets.zero,
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
                  return ResultCard(doc.data(), controller, context);
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
