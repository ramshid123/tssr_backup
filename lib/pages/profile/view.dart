import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/profile/controller.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/widgets/drawer.dart';

class ProfilePage extends GetView<ProfileController> {
  ProfilePage({super.key});

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Obx(() {
        return CustomDrawer(
            1,
            controller.state.centre_name.value,
            controller.state.email.value,
            controller.state.atc.value,
            controller.state.isAdmin.value,
            sf: controller.state.sharedPrefInstance!);
      }),
      body: Container(
        height: Get.height,
        // width: Get.width,// comment for applying bg photo
        // color: Colors.black.withOpacity(0.05),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/home_bg.jpg',
            ),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
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
                child: Obx(() {
                  return Column(
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
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: ColorConstants.blachish_clr,
                          child: CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.white,
                              child: Image.asset(
                                'assets/ic_launcher.png',
                                width: 160,
                                height: 160,
                              )),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: Get.width,
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: Offset(-2, 2))
                            ]),
                        child: Column(
                          children: [
                            Text(
                              controller.state.email.value,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              controller.state.centre_name.value,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: Get.width,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: Offset(-2, 2))
                            ]),
                        child: Column(
                          children: [
                            SecondBoxItem('ATC Code', Icons.numbers,
                                controller.state.atc.value),
                            SecondBoxItem('Centre Head', Icons.person,
                                controller.state.centre_head.value),
                            SecondBoxItem('Centre Name', Icons.sort_by_alpha,
                                controller.state.centre_name.value),
                            SecondBoxItem('Place', Icons.place,
                                controller.state.place.value),
                            SecondBoxItem('District', Icons.place_outlined,
                                controller.state.district.value),
                            SecondBoxItem('Renewal', Icons.date_range,
                                controller.state.renewal.value),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget SecondBoxItem(String title, IconData icon, String info) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey[600], size: 15),
              SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              info,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 19,
              ),
            ),
          ),
          SizedBox(height: 10),
          //    Align(
          //   alignment: Alignment.center,
          //   child: Container(
          //     height: 1,
          //     width: Get.width*0.66,
          //     color: ColorConstants.purple_clr,
          //   ),
          // ),
        ],
      ));
}
