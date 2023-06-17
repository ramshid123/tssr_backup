import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/student_upload/controller.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';
import 'package:tssr_ctrl/widgets/tssc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

class StudentUpload extends GetView<StudentUploadController> {
  const StudentUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar('Student Details'),
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
                                    hintText: 'Name',
                                    ctrl: controller.state.st_name),
                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Register No',
                                    ctrl: controller.state.reg_no),
                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Date of Birth',
                                    context: context,
                                    ctrl: controller.state.st_dob),
                                SizedBox(height: 30),
                                RadioButtonWidget(
                                    controller.state.st_gender), //   Gender
                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Aadhaar Number',
                                    ctrl: controller.state.st_aadhar),
                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Address',
                                    ctrl: controller.state.st_address),
                                SizedBox(height: 30),
                                DropDownListWidget(
                                    controller.state.districts,
                                    controller.state.st_district,
                                    'District'), // District
                                SizedBox(height: 30),
                                DropDownListWidget(
                                    controller.state.availableCourses.value,
                                    controller.state.course,
                                    'Course'), // Course

                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'PinCode',
                                    ctrl: controller.state.st_pincode),
                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Mobile No',
                                    ctrl: controller.state.st_mobile_no),
                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Email',
                                    ctrl: controller.state.st_email),

                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Date of Admission',
                                    context: context,
                                    ctrl: controller
                                        .state.date_of_admission), //// Date of admission

                                SizedBox(height: 30),
                                CustomTextForm(
                                    hintText: 'Course Starting Date',
                                    context: context,
                                    ctrl: controller
                                        .state.date_of_course_start), //// course start date
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
                                                    BorderRadius.circular(
                                                        10))),
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
                              SizedBox(height: 100),
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

Widget DropDownListWidget(
    List<String> items, TextEditingController value, String label) {
  return DropdownSearch<String>(
    popupProps: PopupProps.menu(
      showSelectedItems: true,
    ),
    items: items,
    dropdownDecoratorProps: DropDownDecoratorProps(
      dropdownSearchDecoration: InputDecoration(
        labelText: label,
      ),
    ),
    onChanged: (val) {
      value.text = val!;
    },
    selectedItem: items[0],
    validator: (value) {
      if (value!.contains('Select')) return 'Required*';
      return null;
    },
  );
}

Widget RadioButtonWidget(TextEditingController value) {
  return CustomRadioButton(
      elevation: 1,
      enableShape: true,
      shapeRadius: 50,
      absoluteZeroSpacing: false,
      unSelectedColor: Colors.white,
      buttonLables: [
        'Male',
        'Female',
        'Other',
      ],
      buttonValues: [
        "Male",
        "Female",
        "Other",
      ],
      buttonTextStyle: ButtonTextStyle(
          selectedColor: Colors.white,
          unSelectedColor: Colors.black,
          textStyle: TextStyle(fontSize: 16)),
      radioButtonValue: (val) {
        value.text = val;
      },
      selectedColor: ColorConstants.purple_clr);
}
