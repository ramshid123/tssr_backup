import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/study_centre/atc_requests/controller.dart';
import 'package:tssr_ctrl/pages/ADMIN/study_centre/atc_requests/widgets.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/widgets/optionsBar_tssr.dart';

class AtcRequestsPageView extends GetView<AtcRequestsPageController> {
  const AtcRequestsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      bool isMobile = Get.width <= 768 ? true : false;
      return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: CustomAppBar('Atc Requests'),
        body: Padding(
          padding: isMobile
              ? EdgeInsets.zero
              : EdgeInsets.symmetric(horizontal: Get.width / 20),
          child: FirestoreListView(
            query: DatabaseService.atcRequestsCollection,
            emptyBuilder: (context) => Center(
              child: Text(
                'No Requests',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            itemBuilder: (context, doc) {
              return atcRequestTile(doc: doc, controller: controller);
            },
            pageSize: 5,
          ),
        ),
      );
    });
  }
}
