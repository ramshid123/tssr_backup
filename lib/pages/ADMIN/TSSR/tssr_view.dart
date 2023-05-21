import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/pages/ADMIN/T Store(admin)/view.dart';
import 'package:tssr_ctrl/routes/names.dart';

class TSSRHomePage extends StatelessWidget {
  const TSSRHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('TSSR'),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            SizedBox(height: 60),
            Text(
              'TSSR Services',
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
                TstoreButton('Upload TSSR Data', Icons.upload,
                    AppRouteNames.TSSR_UPLOAD),
                TstoreButton('View TSSR Data', Icons.data_thresholding_outlined,
                    AppRouteNames.TSSR_ADMIN),
                TstoreButton(
                    'Upload Hall Ticket',
                    Icons.format_list_bulleted_add,
                    AppRouteNames.HALL_TICKET_UPLOAD),
                TstoreButton('View Hall Ticket', Icons.format_list_bulleted,
                    AppRouteNames.HALL_TICKET_VIEW),
                TstoreButton('Result Upload', Icons.assignment_add, '/'),
                TstoreButton('Result View', Icons.assessment, '/'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
