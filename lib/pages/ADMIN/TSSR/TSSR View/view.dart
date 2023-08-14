import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR/TSSR%20View/tssrpage_index.dart';
import 'package:tssr_ctrl/routes/names.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/widgets/tssr.dart';
import 'package:tssr_ctrl/widgets/optionsBar_tssr.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';

class TssrPage extends GetView<TssrPageController> {
  const TssrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // bool isMobile = Get.width <= 768 ? true : false;
      return Scaffold(
        backgroundColor: Colors.grey[100],
        // appBar: isMobile ? CustomAppBar('TSSR') : null,
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
              padding: EdgeInsets.zero,
              // padding: isMobile
              //     ? EdgeInsets.zero
              //     : EdgeInsets.symmetric(horizontal: Get.width / 20),
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
                  return TssrCard(doc.data(), controller, context);
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
