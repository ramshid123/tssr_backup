import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
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
    return Scaffold(
      appBar: CustomAppBar('T Store'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add, size: 40),
      ),
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
            itemBuilder: (context, doc) {
              return TStoreCardAdmin(doc.data());
            },
            pageSize: 5,
          );
        }),
      ),
    );
  }
}
