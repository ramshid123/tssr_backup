import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR/result%20upload/controller.dart';
import 'package:tssr_ctrl/services/excel_service.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/widgets/tssc.dart';

class ResultUploadPage extends GetView<ResultUploadController> {
  const ResultUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar('Result'),
        body: Obx(() {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: false,
                snap: true,
                floating: true,
                flexibleSpace: Container(
                  color: Color(0xfffafafa),
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CupertinoSegmentedControl(
                          padding: EdgeInsets.zero,
                          borderColor: Color(0xfffafafa),
                          pressedColor: Color(0xfffafafa),
                          selectedColor: ColorConstants.blachish_clr,
                          unselectedColor: Color(0xfffafafa),
                          groupValue: controller.state.stepIndex.value,
                          children: {
                            0: buildSegment('Manual'),
                            '': buildSegment('OR'),
                            1: buildSegment('Excel'),
                          },
                          onValueChanged: (val) {
                            if (val.toString().length > 0)
                              controller.state.stepIndex.value =
                                  int.parse(val.toString());
                          },
                        ),
                      ),
                      Container(
                        height: 1,
                        width: 200,
                        color: ColorConstants.greenish_clr,
                      )
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 10),
                  controller.state.stepIndex.value == 0
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: controller.state.formkey,
                            child: Column(
                              children: [
                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Register No',
                                    ctrl: controller.state.regNo),
                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Name',
                                    ctrl: controller.state.name),
                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Course',
                                    ctrl: controller.state.course),
                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Duration',
                                    ctrl: controller.state.duration),
                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Study Centre',
                                    ctrl: controller.state.studyCentre),
                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Exam Centre',
                                    context: context,
                                    ctrl: controller.state.examCentre),
                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Exam Date',
                                    context: context,
                                    ctrl: controller.state.examDate),
                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Result',
                                    ctrl: controller.state.result),
                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Grade',
                                    ctrl: controller.state.grade),
                                SizedBox(height: 40),
                                controller.state.isLoading.value
                                    ? SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(),
                                      )
                                    : ElevatedButton(
                                        onPressed: () async {
                                          await controller.manualDataSubmit();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            fixedSize: Size(Get.width, 50),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                        child: Text('Submit')),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 50),
                              Text(
                                'Download the Dummy or Model of Excel sheet which is to be uploaded',
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () async => await ExcelService()
                                    .createSkeletonExcelFiles(
                                        titles: [
                                      'reg_no',
                                      'name',
                                      'course',
                                      'study_centre',
                                      'exam_centre',
                                      'duration',
                                      'exam_date',
                                      'result',
                                      'grade',
                                    ],
                                        fileName: 'Result_Data_Skeleton',
                                        context: context),
                                child: Text('Download '),
                              ),
                              SizedBox(height: 50),
                              Text(
                                'Select the Excel file with .xlsx extension. The sheet should be properly structured accordingly.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 20),
                              controller.state.isLoading.value
                                  ? SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: CircularProgressIndicator())
                                  : ElevatedButton(
                                      onPressed: () async {
                                        await controller.selectAndUploadExcel();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: Size(Get.width, 60),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      child: Text(
                                        'Select and Upload',
                                        style: TextStyle(
                                            fontSize: 17, letterSpacing: 2),
                                      ),
                                    ),
                            ],
                          ),
                        )
                ]),
              )
            ],
          );
        }));
  }
}

Widget buildSegment(String text) {
  return Container(
    // width: Get.width/3,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: Text(
      text,
      style: TextStyle(
          fontSize: 20,
          color: text == 'OR' ? ColorConstants.purple_clr : null,
          fontWeight: text == 'OR' ? FontWeight.bold : null),
    ),
  );
}
