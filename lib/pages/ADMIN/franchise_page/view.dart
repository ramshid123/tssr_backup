import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/pages/ADMIN/franchise_page/controller.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/widgets/franchise.dart';
import 'package:tssr_ctrl/widgets/optionsBar_tssr.dart';

class FranchisePage extends GetView<FranchisePageController> {
  const FranchisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar('Franchise'),
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
          return FirestoreListView(
            query: controller.state.query.value,
            itemBuilder: (context, doc) {
              return FranchiseCard(doc.data(), controller);
            },
            pageSize: 5,
          );
        }),
      ),
    );
  }
}
