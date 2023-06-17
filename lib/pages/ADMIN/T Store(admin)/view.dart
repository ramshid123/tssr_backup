import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/routes/names.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';

class TStoreAdmin extends StatelessWidget {
  const TStoreAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('T Store'),
      body: LayoutBuilder(builder: (context, constraints) {
        bool isMobile = Get.width <= 768 ? true : false;
        return SizedBox(
          height: Get.height,
          width: Get.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 60),
                Text(
                  'T-Store Services',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 1,
                  width: 100,
                  color: ColorConstants.blachish_clr,
                ),
                SizedBox(height: 30),
                Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 20,
                  spacing: 20,
                  children: [
                    TstoreButton(
                        'Orders',
                        Icons.playlist_add_check_circle_outlined,
                        AppRouteNames.TSTORE_ADMIN_ORDERS,
                        isMobile),
                    TstoreButton('Books', Icons.book_outlined,
                        AppRouteNames.TSTORE_ADMIN_BOOKS, isMobile),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

Widget TstoreButton(String title, IconData icon, String route, bool isMobile) {
  return ElevatedButton(
    onPressed: () => Get.toNamed(route),
    style: ElevatedButton.styleFrom(
      fixedSize: isMobile
          ? Size(Get.width * 0.4, Get.width * 0.4)
          : Size(Get.width * 0.2, Get.width * 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: Get.width / (isMobile ? 13 : 26),
          backgroundColor: Colors.white,
          child: Icon(
            icon,
            size: Get.width /(isMobile? 10:20),
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: Get.width * 0.4,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    ),
  );
}
