import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/T%20Store(admin)/orders/torders_index.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/widgets/optionsBar_tssr.dart';
import 'package:tssr_ctrl/widgets/order_card.dart';

class TOrdersPage extends GetView<TOrdersController> {
  const TOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      bool isMobile = Get.width <= 768 ? true : false;
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: isMobile ? CustomAppBar('TStore') : null,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              flexibleSpace: OptionsBarForTstore(
                  context, controller, ['Name', 'buyer_name', 'Date', 'Epoch']),
              toolbarHeight: 60,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              pinned: false,
              floating: true,
              snap: true,
              stretch: true,
            ),
          ],
          body: Padding(
            padding: isMobile
                ? EdgeInsets.zero
                : EdgeInsets.symmetric(horizontal: Get.width / 20),
            child: Obx(() {
              return controller.state.stepIndex.value == 0
                  ? FirestoreListView(
                      query: controller.state.inComingquery.value,
                      emptyBuilder: (context) => Center(
                        child: Text(
                          'No InComing Orders',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      itemBuilder: (context, doc) {
                        return TOrderCard(doc.data(), controller);
                      },
                      pageSize: 5,
                    )
                  : FirestoreListView(
                      query: controller.state.onGoingquery.value,
                      emptyBuilder: (context) => Center(
                        child: Text(
                          'No OnGoing Orders',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      itemBuilder: (context, doc) {
                        return TOrderCard(doc.data(), controller);
                      },
                      pageSize: 5,
                    );
            }),
          ),
        ),
      );
    });
  }
}
