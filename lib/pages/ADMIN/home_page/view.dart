import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR%20Page/tssrpage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/home_page/controller.dart';
import 'package:tssr_ctrl/routes/names.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';
import 'package:tssr_ctrl/widgets/drawer.dart';
import 'package:http/http.dart' as http;

class HomePage extends GetView<HomePageController> {
  HomePage({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await http.get(Uri.parse('https://randomuser.me/api'));
          final json = jsonDecode(result.body.toString());
          print(json['results'][0]['gender']);
        },
      ),
      drawer: Obx(() {
        return CustomDrawer(
            0,
            controller.state.centre_name.value,
            controller.state.email.value,
            controller.state.atc.value,
            controller.state.isAdmin.value);
      }),
      body: Container(
        height: Get.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/home_bg.jpg',
                ),
                fit: BoxFit.cover,
                opacity: 0.3)),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  height: 200,
                  width: Get.width,
                  decoration: BoxDecoration(
                      color: ColorConstants.blachish_clr,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            _scaffoldKey.currentState!.openDrawer();
                          },
                          icon: Icon(Icons.menu,
                              size: 35, color: ColorConstants.greenish_clr),
                          padding: EdgeInsets.only(left: 20),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.notifications,
                              size: 35, color: ColorConstants.greenish_clr),
                          padding: EdgeInsets.only(right: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Info Card
                    Obx(() {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                        width: Get.width,
                        decoration: BoxDecoration(
                          // color: ColorConstants.purple_clr,
                          gradient: LinearGradient(
                              colors: [
                                ColorConstants.purple_clr,
                                Colors.purple
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          boxShadow: [
                            BoxShadow(
                                color: ColorConstants.blachish_clr,
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(-2, 2))
                          ],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.purple,
                                    size: 50,
                                  ),
                                ),
                                SizedBox(width: 20),
                                SizedBox(
                                  width: Get.width / 2 - 20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.state.centre_name.value,
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        controller.state.centre_head.value,
                                        style: TextStyle(
                                            fontSize: 23,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        controller.state.atc.value,
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 30),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        HomeScreenButton('TSSR Upload', Icons.upload,
                            AppRouteNames.TSSR_UPLOAD),
                        HomeScreenButton(
                            'TSSR Data',
                            Icons.data_thresholding_outlined,
                            AppRouteNames.TSSR_ADMIN),
                        HomeScreenButton('TSSC Upload', Icons.upload_outlined,
                            AppRouteNames.TSSC_UPLOAD),
                        HomeScreenButton(
                            'TSSC Data',
                            Icons.data_thresholding_sharp,
                            AppRouteNames.TSSC_ADMIN),
                        HomeScreenButton(
                            'Hall Ticket Upload',
                            Icons.format_list_bulleted_add,
                            AppRouteNames.HALL_TICKET_UPLOAD),
                        HomeScreenButton(
                            'Hall Tickets',
                            Icons.format_list_bulleted,
                            AppRouteNames.HALL_TICKET_VIEW),
                        HomeScreenButton(
                            'Franchise Upload',
                            Icons.add_business_outlined,
                            AppRouteNames.FRANCHISE_UPLOAD),
                        HomeScreenButton(
                            'Franchise Data',
                            Icons.school_outlined,
                            AppRouteNames.FRANCHISE_DATA),
                        HomeScreenButton(
                            'Gallery',
                            Icons.photo_size_select_actual_outlined,
                            AppRouteNames.GALLERY),
                        HomeScreenButton(
                            'Result Upload', Icons.assignment_add, '/'),
                        HomeScreenButton('Result Data', Icons.assessment, '/'),
                        HomeScreenButton('T Store', Icons.storefront_outlined,
                            AppRouteNames.TSTORE_ADMIN),
                        HomeScreenButton(
                            'Report', Icons.bug_report_outlined, '/'),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget HomeScreenButton(String title, IconData icon, String page) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Get.toNamed(page);
          },
          child: Icon(
            icon,
            size: 40,
            color: ColorConstants.greenish_clr,
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.blachish_clr,
              fixedSize: Size(80, 80),
              shape: CircleBorder()),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: Get.width / 3 - 45,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
