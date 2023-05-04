import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/ADMIN/franchise_upload/controller.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/widgets/tssc.dart';

class FranchiseUploadPage extends GetView<FranchiseUploadController> {
  const FranchiseUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: CustomAppBar('Franchise'),
        floatingActionButton: controller.state.currentStep.value == 2
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: 'btn1',
                    onPressed: () {
                      controller.increamentTextForms();
                    },
                    child: Icon(Icons.add),
                  ),
                  SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: 'btn2',
                    onPressed: () {
                      controller.decreamentTextForms();
                    },
                    child: Icon(Icons.remove),
                    backgroundColor: Colors.white,
                    shape: CircleBorder(
                        side: BorderSide(
                            color: ColorConstants.purple_clr, width: 2)),
                    foregroundColor: ColorConstants.purple_clr,
                  ),
                ],
              )
            : null,
        body: Stepper(
          physics: BouncingScrollPhysics(),
          type: StepperType.vertical,
          currentStep: controller.state.currentStep.value,
          controlsBuilder: (context, details) {
            return Padding(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await controller.manualSingleUpload();
                    },
                    child: Text(controller.state.currentStep.value == 2
                        ? 'Continue'
                        : 'Next'),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        fixedSize: Size(100, 30)),
                  ),
                  SizedBox(width: 10),
                  controller.state.currentStep.value != 0
                      ? ElevatedButton(
                          onPressed: () async {
                            controller.previousButton();
                          },
                          child: Text('Previous'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: ColorConstants.purple_clr,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                      color: ColorConstants.purple_clr,
                                      width: 2)),
                              fixedSize: Size(100, 30)),
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
                      CustomTextForm(
                          hintText: 'ATC Code', ctrl: controller.state.atc),
                      SizedBox(height: 20),
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
              content: ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => test(
                  'Course ${index + 1}',
                  controller,
                  index,
                ),
                itemCount: controller.state.courseLength.value,
              ),
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
