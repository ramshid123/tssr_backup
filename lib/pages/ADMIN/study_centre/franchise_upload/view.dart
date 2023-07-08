import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/models/time_api_model.dart';
import 'package:tssr_ctrl/pages/ADMIN/study_centre/franchise_upload/controller.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/widgets/tssc.dart';
import 'package:http/http.dart' as http;

class FranchiseUploadPage extends GetView<FranchiseUploadController> {
  const FranchiseUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: CustomAppBar('Franchise'),
        body: Stepper(
          physics: BouncingScrollPhysics(),
          type: StepperType.vertical,
          currentStep: controller.state.currentStep.value,
          controlsBuilder: (context, details) {
            return Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  Obx(() {
                    return controller.state.isLoading.value
                        ? SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              await controller.manualSingleUpload();
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                fixedSize: Size(100, 30)),
                            child: Text(controller.state.currentStep.value == 2
                                ? 'Continue'
                                : 'Next'),
                          );
                  }),
                  SizedBox(width: 10),
                  controller.state.currentStep.value != 0
                      ? ElevatedButton(
                          onPressed: () async {
                            controller.previousButton();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: ColorConstants.purple_clr,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                      color: ColorConstants.purple_clr,
                                      width: 2)),
                              fixedSize: Size(100, 30)),
                          child: Text('Previous'),
                        )
                      : Container(),
                ],
              ),
            );
          },
          steps: [
            Step(
              state: controller.state.currentStep.value > 0
                  ? StepState.complete
                  : StepState.indexed,
              isActive: controller.state.currentStep.value >= 0,
              title: Text('Authentication Details'),
              content: Form(
                key: controller.state.formkey1,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    CustomTextForm(
                        hintText: 'Email', ctrl: controller.state.email),
                    SizedBox(height: 20),
                    CustomTextForm(
                        hintText: 'Password', ctrl: controller.state.password),
                  ],
                ),
              ),
            ),
            Step(
                state: controller.state.currentStep.value > 1
                    ? StepState.complete
                    : StepState.indexed,
                isActive: controller.state.currentStep.value >= 1,
                title: Text('Franchise Details'),
                content: Form(
                  key: controller.state.formkey2,
                  child: Column(
                    children: [
                      // CustomTextForm(
                      //     hintText: 'ATC Code', ctrl: controller.state.atc),
                      // SizedBox(height: 20),
                      CustomTextForm(
                          hintText: 'Centre Head',
                          ctrl: controller.state.centre_head),
                      SizedBox(height: 20),
                      CustomTextForm(
                          hintText: 'Centre Name',
                          ctrl: controller.state.centre_name),
                      SizedBox(height: 20),
                      CustomTextForm(
                          hintText: 'District',
                          ctrl: controller.state.district),
                      SizedBox(height: 20),
                      CustomTextForm(
                          hintText: 'Place', ctrl: controller.state.place),
                      SizedBox(height: 20),
                      CustomTextForm(
                          hintText: 'Renewal Date',
                          ctrl: controller.state.renewal,
                          context: context),
                      SizedBox(height: 30),
                    ],
                  ),
                )),
            Step(
                state: controller.state.currentStep.value > 2
                    ? StepState.complete
                    : StepState.indexed,
                isActive: controller.state.currentStep.value >= 2,
                title: Text('Course Details'),
                content: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      GetBuilder(
                          init: controller,
                          builder: (ctrl) {
                            return Text(
                              'Selected Courses : ${ctrl.state.SelectedCourses.value.length}',
                            );
                          }),
                      ElevatedButton(
                        onPressed: () async => Get.defaultDialog(
                          title: 'Add Courses',
                          content: Container(
                            height: Get.height - 200,
                            width: Get.width,
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                            color: Colors.white,
                            child: Column(
                              children: [
                                GetBuilder(
                                    init: controller,
                                    builder: (ctrl) {
                                      return SizedBox(
                                          height: ((Get.height - 200) / 2) - 73,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              final item = ctrl.state
                                                  .SelectedCourses.value[index];
                                              return ListTile(
                                                title: Text(item),
                                                trailing: IconButton(
                                                  onPressed: () async =>
                                                      ctrl.removeCourseFromList(
                                                          item),
                                                  icon:
                                                      Icon(Icons.remove_circle),
                                                ),
                                              );
                                            },
                                            itemCount: ctrl.state
                                                .SelectedCourses.value.length,
                                          ));
                                    }),
                                Container(
                                  height: 1,
                                  width: Get.width,
                                  color: Colors.black,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Search for course..',
                                    ),
                                    onFieldSubmitted: (val) =>
                                        controller.searchUsingGivenString(val),
                                  ),
                                ),
                                GetBuilder(
                                    init: controller,
                                    builder: (ctrl) {
                                      return SizedBox(
                                        height: ((Get.height - 200) / 2),
                                        child: FirestoreListView(
                                          shrinkWrap: true,
                                          query: ctrl.state.allCourseQuery,
                                          pageSize: 10,
                                          emptyBuilder: (context) => Center(
                                            child: Text(
                                              'No Data',
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ),
                                          itemBuilder: (context, doc) =>
                                              KCourseListViewItem(
                                                  doc.data()['course'], ctrl),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                        child: Text('Add Courses'),
                      ),
                    ],
                  ),
                )
                // content: ListView.builder(
                //   physics: BouncingScrollPhysics(),
                //   shrinkWrap: true,
                //   itemBuilder: (context, index) => test(
                //     'Course ${index + 1}',
                //     controller,
                //     index,
                //   ),
                //   itemCount: controller.state.courseLength.value,
                // ),
                )
          ],
        ),
      );
    });
  }
}

Widget test(String hintText, FranchiseUploadController controller, int index) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.deepPurple[100],
        hintText: hintText,
        enabled: true,
        focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: ColorConstants.greenish_clr, width: 2)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.purple_clr, width: 2)),
        // validator: (val) {
        //   if (val!.isEmpty) return 'Required';

        //   return null;
        // },
      ),
      onChanged: (val) {
        controller.state.courseList[index] = val;
      },
    ),
  );
}

Widget KCourseListViewItem(
  String title,
  FranchiseUploadController controller,
) {
  return ListTile(
    title: Text(title),
    trailing: IconButton(
      onPressed: () async => controller.addCourseToList(title),
      icon: Icon(Icons.add_circle),
    ),
  );
}
