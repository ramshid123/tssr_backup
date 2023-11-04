import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/home(FR)/controller.dart';
import 'package:tssr_ctrl/routes/names.dart';
import 'package:tssr_ctrl/services/excel_service.dart';
import 'package:tssr_ctrl/widgets/drawer.dart';

import '../student_upload/controller.dart';

class HomeFrPage extends GetView<HomeFrController> {
  HomeFrPage({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Obx(() {
        return CustomDrawer(
            0,
            controller.state.centre_name.value,
            controller.state.email.value,
            controller.state.atc.value,
            controller.state.isAdmin.value,
            sf: controller.state.sharedPrefInstance!);
      }),
      body: LayoutBuilder(builder: (context, c) {
        bool isMobile = Get.width <= 768 ? true : false;
        return isMobile
            ? Container(
                height: Get.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(
                    'assets/home_bg.jpg',
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.3,
                )),
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
                                      size: 35,
                                      color: ColorConstants.greenish_clr),
                                  padding: EdgeInsets.only(left: 20),
                                ),
                                IconButton(
                                  onPressed: () async => await Get.toNamed(
                                      AppRouteNames.NOTIFICATION_CLIENT),
                                  icon: Icon(Icons.notifications,
                                      size: 35,
                                      color: ColorConstants.greenish_clr),
                                  padding: EdgeInsets.only(right: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            // Info Card
                            Obx(() {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
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
                                          child: Image.asset(
                                            'assets/ic_launcher.png',
                                            height: 100,
                                            width: 100,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        SizedBox(
                                          width: Get.width / 2 - 25,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.state.place.value,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                controller
                                                    .state.centre_name.value,
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                controller.state.atc.value,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
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
                                HomeScreenButton('Student Data Upload',
                                    Icons.upload, AppRouteNames.STUDENT_UPLOAD),
                                HomeScreenButton(
                                    'Student Data',
                                    Icons.data_thresholding_outlined,
                                    AppRouteNames.STUDENT_VIEW),
                                HomeScreenButton(
                                    'T Store',
                                    Icons.storefront_outlined,
                                    AppRouteNames.T_STORE_FR),
                                HomeScreenButton(
                                    'Approved Courses',
                                    Icons.menu_book_outlined,
                                    AppRouteNames.MY_COURSES_PAGE),
                                HomeScreenButton(
                                    'Report',
                                    Icons.bug_report_outlined,
                                    AppRouteNames.REPORT_HOME_PAGE_FR),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Container(
                height: Get.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(
                    'assets/home_bg.jpg',
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.3,
                )),
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
                                      size: 35,
                                      color: ColorConstants.greenish_clr),
                                  padding: EdgeInsets.only(left: 20),
                                ),
                                IconButton(
                                  onPressed: () async => await Get.toNamed(
                                      AppRouteNames.NOTIFICATION_CLIENT),
                                  icon: Icon(Icons.notifications,
                                      size: 35,
                                      color: ColorConstants.greenish_clr),
                                  padding: EdgeInsets.only(right: 20),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            // Info Card
                            Obx(() {
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 30),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                width: Get.width / 2,
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
                                          child: Image.asset(
                                            'assets/ic_launcher.png',
                                          ),
                                        ),
                                        SizedBox(width: 40),
                                        SizedBox(
                                          width: Get.width / 4 - 20,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.state.place.value,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                controller
                                                    .state.centre_name.value,
                                                style: TextStyle(
                                                    fontSize: 23,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                controller.state.atc.value,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
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
                                HomeScreenButton('Student Data Upload',
                                    Icons.upload, AppRouteNames.STUDENT_UPLOAD),
                                HomeScreenButton(
                                    'Student Data',
                                    Icons.data_thresholding_outlined,
                                    AppRouteNames.STUDENT_VIEW),
                                HomeScreenButton(
                                    'T Store',
                                    Icons.storefront_outlined,
                                    AppRouteNames.T_STORE_FR),
                                HomeScreenButton(
                                    'Approved Courses',
                                    Icons.menu_book_outlined,
                                    AppRouteNames.MY_COURSES_PAGE),
                                HomeScreenButton(
                                    'Report',
                                    Icons.bug_report_outlined,
                                    AppRouteNames.REPORT_HOME_PAGE_FR),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
      }),
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
          style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstants.blachish_clr,
              fixedSize: Size(80, 80),
              shape: CircleBorder()),
          child: Icon(
            icon,
            size: 40,
            color: ColorConstants.greenish_clr,
          ),
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
