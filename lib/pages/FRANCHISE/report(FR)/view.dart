import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/report(FR)/controller.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/services/pdf_service.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/routes/names.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
// import 'package:pdfx/pdfx.dart' as pdfx;

class ReportFranchisePage extends GetView<ReportFranchiseController> {
  const ReportFranchisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Report'),
      body: LayoutBuilder(builder: (context, c) {
        bool isMobile = Get.width <= 768 ? true : false;
        return GetBuilder(
            init: controller,
            builder: (controller) {
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
                      controller.state.canAccessReports == null ||
                              controller.state.canAccessReports!
                          ? FirestoreListView(
                              shrinkWrap: true,
                              query: DatabaseService.MetaInformations,
                              itemBuilder: (context, doc) {
                                return doc.data()['can_access_reports']
                                    ? Wrap(
                                        alignment: WrapAlignment.center,
                                        runSpacing: 20,
                                        spacing: 20,
                                        children: [
                                          ReportPageButton(
                                            'Student Details\n(All Courses)',
                                            isMobile: isMobile,
                                            context: context,
                                            controller: controller,
                                            isPPTC: false,
                                            pgmd: pageMode.potrait,
                                            gdmd: GetDataMode.studentDetails,
                                          ),
                                          ReportPageButton(
                                            'Attendence Register\n(All Courses)',
                                            isMobile: isMobile,
                                            context: context,
                                            controller: controller,
                                            isPPTC: false,
                                            pgmd: pageMode.potrait,
                                            gdmd:
                                                GetDataMode.attendanceRegister,
                                          ),
                                          ReportPageButton(
                                              'Class Test Marksheet\n(PPTTC/MTTC/PM/AM/AC) Course',
                                              controller: controller,
                                              isPPTC: true,
                                              context: context,
                                              pgmd: pageMode.landscape,
                                              gdmd: GetDataMode.pptcClassTest,
                                              isMobile: isMobile),
                                          ReportPageButton(
                                              'Commision Marksheet\n(PPTTC/MTTC) Course',
                                              controller: controller,
                                              isPPTC: true,
                                              context: context,
                                              pgmd: pageMode.potrait,
                                              gdmd: GetDataMode.pptcCommision,
                                              isMobile: isMobile),
                                          ReportPageButton(
                                              'Craft & Practical Work\n(PPTTC/MTTC) Course',
                                              controller: controller,
                                              isPPTC: true,
                                              context: context,
                                              pgmd: pageMode.landscape,
                                              gdmd: GetDataMode.pptcPractical,
                                              isMobile: isMobile),
                                          ReportPageButton(
                                              'Teaching Practice Marksheet\n(PPTTC/MTTC) Course',
                                              controller: controller,
                                              isPPTC: true,
                                              context: context,
                                              pgmd: pageMode.potrait,
                                              gdmd: GetDataMode
                                                  .pptcTeachingPractice,
                                              isMobile: isMobile),
                                          SizedBox(
                                              width: Get.width, height: 10),
                                        ],
                                      )
                                    : Center(
                                        child: Text(
                                          'Access to the reports is temporarily denied',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      );
                              })
                          : Center(
                              child: Text(
                                'Access to the reports is temporarily denied',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}

Widget ReportPageButton(String title,
    {required ReportFranchiseController controller,
    required bool isPPTC,
    required pageMode pgmd,
    required GetDataMode gdmd,
    required bool isMobile,
    required BuildContext context}) {
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
      Get.bottomSheet(Container(
        height: Get.height / 2,
        width: Get.width,
        color: Colors.white,
        child: FirestoreListView(
          query: DatabaseService.FranchiseCollection.where('centre_name',
              isEqualTo: controller.state.franchiseName),
          itemBuilder: (context, doc) {
            final courses = doc.data()['courses'];
            print(courses);
            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(courses[index]),
                  onTap: () async {
                    await PdfApi().generateDocument(
                        context: context,
                        controller: controller,
                        course: courses[index],
                        orgName: controller.state.franchiseName!,
                        pgMode: pgmd,
                        outputFormat: outputFormat,
                        dataMode: gdmd,
                        isPPTC: isPPTC);
                  },
                );
              },
              itemCount: courses.length,
            );
          },
        ),
        // child: FirestoreListView(
        //   query: DatabaseService.FranchiseCollection.where('centre_name',
        //       isEqualTo: controller.state.franchiseName),
        //   itemBuilder: (context, doc) {
        //     final item = doc.data();
        //     return ListTile(
        //       title: Text(item['course']),
        //       onTap: () async {
        //         await PdfApi().generateDocument(
        //             context: context,
        //             controller: controller,
        //             course: item['course'],
        //             orgName: controller.state.franchiseName!,
        //             pgMode: pgmd,
        //             outputFormat: outputFormat,
        //             dataMode: gdmd,
        //             isPPTC: false);
        //       },
        //     );
        //   },
        // ),
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
}
