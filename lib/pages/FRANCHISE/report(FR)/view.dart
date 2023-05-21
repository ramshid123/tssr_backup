import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/report(FR)/controller.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/services/pdf_service.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/routes/names.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';

class ReportFranchisePage extends GetView<ReportFranchiseController> {
  const ReportFranchisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Report'),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 60),
              Text(
                'Report Services',
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
                  ReportPageButton(
                    'Student Details',
                    controller,
                    pgmd: pageMode.potrait,
                    gdmd: GetDataMode.studentDetails,
                  ),
                  SizedBox(width: Get.width, height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget ReportPageButton(String title, ReportFranchiseController controller,
    {required pageMode pgmd, required GetDataMode gdmd}) {
  return ElevatedButton(
    onPressed: () async {
      await PdfApi().generateDocument(
          orgName: controller.state.franchiseName!,
          pgMode: pgmd,
          dataMode: gdmd,
          isPPTC: false);
    },
    child: SizedBox(
      width: Get.width * 0.4,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
    style: ElevatedButton.styleFrom(
      fixedSize: Size(Get.width * 0.4, Get.width * 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
