import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/ADMIN/report_/report_view.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/services/pdf_service.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'reportadminpage_index.dart';
import 'package:tssr_ctrl/routes/names.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

class ReportAdminPage extends GetView<ReportAdminPageController> {
  const ReportAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Report'),
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
                    ReportPageButton('Student Details\n(All Courses)',
                        controller: controller,
                        isPPTC: false,
                        ctx: context,
                        pgmd: pageMode.potrait,
                        gdmd: GetDataMode.studentDetails,
                        isMobile: isMobile),
                    ReportPageButton('Attendence Register\n(All Courses)',
                        controller: controller,
                        isPPTC: false,
                        ctx: context,
                        pgmd: pageMode.potrait,
                        gdmd: GetDataMode.attendanceRegister,
                        isMobile: isMobile),
                    ReportPageButton('Camp Report',
                        controller: controller,
                        isPPTC: true,
                        pgmd: pageMode.potrait,
                        ctx: context,
                        gdmd: GetDataMode.pptcCamp,
                        isMobile: isMobile),
                    ReportPageButton(
                        'Class Test Marksheet\n(PPTTC/MTTC/PM/AM/AC) Course',
                        controller: controller,
                        isPPTC: true,
                        ctx: context,
                        pgmd: pageMode.landscape,
                        gdmd: GetDataMode.pptcClassTest,
                        isMobile: isMobile),
                    ReportPageButton('Commision Marksheet\n(PPTTC/MTTC) Course',
                        controller: controller,
                        isPPTC: true,
                        ctx: context,
                        pgmd: pageMode.potrait,
                        gdmd: GetDataMode.pptcCommision,
                        isMobile: isMobile),
                    ReportPageButton('Craft Report',
                        controller: controller,
                        isPPTC: true,
                        ctx: context,
                        pgmd: pageMode.landscape,
                        gdmd: GetDataMode.pptcCraft,
                        isMobile: isMobile),
                    ReportPageButton('Fest Report',
                        controller: controller,
                        isPPTC: true,
                        ctx: context,
                        pgmd: pageMode.potrait,
                        gdmd: GetDataMode.pptcFest,
                        isMobile: isMobile),
                    ReportPageButton(
                        'Craft & Practical Work\n(PPTTC/MTTC) Course',
                        controller: controller,
                        isPPTC: true,
                        ctx: context,
                        pgmd: pageMode.landscape,
                        gdmd: GetDataMode.pptcPractical,
                        isMobile: isMobile),
                    ReportPageButton(
                        'Teaching Practice Marksheet\n(PPTTC/MTTC) Course',
                        controller: controller,
                        isPPTC: true,
                        ctx: context,
                        pgmd: pageMode.potrait,
                        gdmd: GetDataMode.pptcTeachingPractice,
                        isMobile: isMobile),
                    ReportPageButton('Tour Report',
                        controller: controller,
                        isPPTC: true,
                        ctx: context,
                        pgmd: pageMode.potrait,
                        gdmd: GetDataMode.pptcTour,
                        isMobile: isMobile),
                    SizedBox(width: Get.width, height: 10),
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

Widget ReportPageButton(String title,
    {required pageMode pgmd,
    required GetDataMode gdmd,
    required BuildContext ctx,
    required bool isPPTC,
    required ReportAdminPageController controller,
    required bool isMobile}) {
  return GetBuilder(
      init: controller,
      builder: (controller) {
        return ElevatedButton(
          onPressed: () async {
            OutputFormat outputFormat = OutputFormat.pdf;
            await Get.bottomSheet(Container(
              height: 100,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                        outputFormat = OutputFormat.pdf;
                      },
                      child: Text('PDF')),
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                        outputFormat = OutputFormat.excel;
                      },
                      child: Text('Excel')),
                ],
              ),
            ));
            await Get.defaultDialog(
                title: 'Options',
                content: controller.state.isLoading.value
                    ? SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              Get.bottomSheet(Container(
                                height: Get.height / 2,
                                width: Get.width,
                                color: Colors.white,
                                child: FirestoreListView(
                                  query: DatabaseService.CourseCollection,
                                  itemBuilder: (context, doc) {
                                    final item = doc.data();
                                    return ListTile(
                                      title: Text(item['course']),
                                      onTap: () async {
                                        await PdfApi().generateDocument(
                                            context: ctx,
                                            controller: controller,
                                            orgName: '',
                                            course: item['course'],
                                            pgMode: pgmd,
                                            dataMode: gdmd,
                                            outputFormat: outputFormat,
                                            isPPTC: isPPTC);
                                      },
                                    );
                                  },
                                ),
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstants.purple_clr,
                                foregroundColor: Colors.white,
                                fixedSize: Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                            child: Text('All Centre'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              final query =
                                  DatabaseService.FranchiseCollection.where(
                                      'isAdmin',
                                      isEqualTo: 'false');
                              Get.back();
                              await Get.bottomSheet(
                                backgroundColor: Colors.white,
                                Container(
                                  height: Get.height / 2,
                                  child: FirestoreListView(
                                    pageSize: 5,
                                    query: query,
                                    emptyBuilder: (context) => Center(
                                      child: Text(
                                        'No Data',
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    itemBuilder: (context, doc) {
                                      final item = doc.data();
                                      return ListTile(
                                        title: Text(item['centre_name']),
                                        onTap: () async {
                                          Get.back();
                                          Get.bottomSheet(Container(
                                            height: Get.height / 2,
                                            width: Get.width,
                                            color: Colors.white,
                                            child: ListView.builder(
                                              itemBuilder: (context, index) {
                                                final courseItem =
                                                    item['courses'][index];
                                                return ListTile(
                                                  title: Text(courseItem),
                                                  onTap: () async {
                                                    await PdfApi()
                                                        .generateDocument(
                                                            controller:
                                                                controller,
                                                            context: ctx,
                                                            course: courseItem,
                                                            orgName: item[
                                                                'centre_name'],
                                                            isPPTC: isPPTC,
                                                            pgMode: pgmd,
                                                            outputFormat:
                                                                outputFormat,
                                                            dataMode: gdmd);
                                                  },
                                                );
                                              },
                                              itemCount: item['courses'].length,
                                            ),
                                          ));
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstants.purple_clr,
                                foregroundColor: Colors.white,
                                fixedSize: Size(150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                            child: Text('Select Centre'),
                          ),
                        ],
                      ));
          },
          style: ElevatedButton.styleFrom(
            fixedSize: isMobile
                ? Size(Get.width * 0.4, Get.width * 0.4)
                : Size(Get.width * 0.2, Get.width * 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: SizedBox(
            width: isMobile ? Get.width * 0.4 : Get.width * 0.2,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      });
}
