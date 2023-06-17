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
                    ReportPageButton('Student Details',
                        controller: controller,
                        ctx: context,
                        pgmd: pageMode.potrait,
                        gdmd: GetDataMode.studentDetails,
                        isMobile: isMobile),
                    ReportPageButton('PPTC Camp Report',
                        controller: controller,
                        pgmd: pageMode.potrait,
                        ctx: context,
                        gdmd: GetDataMode.pptcCamp,
                        isMobile: isMobile),
                    ReportPageButton('PPTC Class Test',
                        controller: controller,
                        ctx: context,
                        pgmd: pageMode.landscape,
                        gdmd: GetDataMode.pptcClassTest,
                        isMobile: isMobile),
                    ReportPageButton('PPTC Commision',
                        controller: controller,
                        ctx: context,
                        pgmd: pageMode.potrait,
                        gdmd: GetDataMode.pptcCommision,
                        isMobile: isMobile),
                    ReportPageButton('PPTC Craft Report',
                        controller: controller,
                        ctx: context,
                        pgmd: pageMode.landscape,
                        gdmd: GetDataMode.pptcCraft,
                        isMobile: isMobile),
                    ReportPageButton('PPTC Fest Report',
                        controller: controller,
                        ctx: context,
                        pgmd: pageMode.potrait,
                        gdmd: GetDataMode.pptcFest,
                        isMobile: isMobile),
                    ReportPageButton('PPTC Practical',
                        controller: controller,
                        ctx: context,
                        pgmd: pageMode.landscape,
                        gdmd: GetDataMode.pptcPractical,
                        isMobile: isMobile),
                    ReportPageButton('PPTC Teaching Practice',
                        controller: controller,
                        ctx: context,
                        pgmd: pageMode.landscape,
                        gdmd: GetDataMode.pptcTeachingPractice,
                        isMobile: isMobile),
                    ReportPageButton('PPTC Tour',
                        controller: controller,
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
    required ReportAdminPageController controller,
    required bool isMobile}) {
  return GetBuilder(
      init: controller,
      builder: (controller) {
        return ElevatedButton(
          onPressed: () async {
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
                            onPressed: () async => await PdfApi()
                                .generateDocument(
                                    context: ctx,
                                    controller: controller,
                                    orgName: '',
                                    pgMode: pgmd,
                                    dataMode: gdmd,
                                    isPPTC: false),
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
                                          await PdfApi().generateDocument(
                                              controller: controller,
                                              context: ctx,
                                              orgName: item['centre_name'],
                                              isPPTC: false,
                                              pgMode: pgmd,
                                              dataMode: gdmd);
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
