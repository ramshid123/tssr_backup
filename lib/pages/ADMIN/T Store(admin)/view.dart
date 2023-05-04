import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
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
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            SizedBox(height: 60),
            Text('T-Store Services',style: TextStyle(
              fontSize: 20,
            ),),
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
                    'Orders', Icons.playlist_add_check_circle_outlined,AppRouteNames.TSTORE_ADMIN_ORDERS),
                TstoreButton('Books', Icons.book_outlined,AppRouteNames.TSTORE_ADMIN_BOOKS),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget TstoreButton(String title, IconData icon, String route) {
  return ElevatedButton(
    onPressed: () =>Get.toNamed(route),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: Get.width / 13,
          backgroundColor: Colors.white,
          child: Icon(
            icon,
            size: Get.width / 10,
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
    style: ElevatedButton.styleFrom(
      fixedSize: Size(Get.width * 0.4, Get.width * 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
