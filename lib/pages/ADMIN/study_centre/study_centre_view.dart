import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/pages/ADMIN/T Store(admin)/view.dart';
import 'package:tssr_ctrl/routes/names.dart';

class StudyCentreHomePage extends StatelessWidget {
  const StudyCentreHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Study Centres'),
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
                  'Franchise Services',
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
                    TstoreButton('Upload Data', Icons.add_business_outlined,
                        AppRouteNames.FRANCHISE_UPLOAD, isMobile),
                    TstoreButton('View Data', Icons.school_outlined,
                        AppRouteNames.FRANCHISE_DATA, isMobile),
                    TstoreButton('Courses', Icons.menu_book_outlined,
                        AppRouteNames.COURSES_ADMIN, isMobile),
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
