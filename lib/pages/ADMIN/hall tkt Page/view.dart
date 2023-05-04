import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/hall%20tkt%20Page/controller.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/widgets/hall%20ticket.dart';
import 'package:tssr_ctrl/widgets/optionsBar_tssr.dart';

class HallTicketPage extends GetView<HallTicketPageController> {
  const HallTicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar('TSSR Data'),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            flexibleSpace: OptionsBar(context, controller,['Name','name','Admission No','admission_no']),
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
            itemBuilder: (context, doc) {
              return HTCard(doc.data(), controller);
            },
            pageSize: 5,
          );
        }),
      ),
    );
  }
}
