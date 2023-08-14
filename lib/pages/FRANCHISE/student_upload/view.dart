import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/student_upload/controller.dart';
import 'package:tssr_ctrl/routes/shared_pref_strings.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/services/excel_service.dart';
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
                                // SizedBox(height: 30),
                                // CustomTextForm(
                                //     hintText: 'Register No',
                                //     ctrl: controller.state.reg_no),
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
                                    hintText: 'Parent name',
                                    ctrl: controller.state.parent_name),
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
                                    ctrl: controller.state
                                        .date_of_admission), //// Date of admission

                                SizedBox(height: 30),
                                DropDownListWidget(
                                    controller.state.batches,
                                    controller.state.date_of_course_start,
                                    'Course batch'),
                                SizedBox(height: 30),
                                kPhotoSelectionButton(
                                    context: context,
                                    buttonText: 'Upload profile photo',
                                    compressedFile:
                                        controller.state.photo_compressed,
                                    file: controller.state.photo_path),
                                SizedBox(height: 30),
                                kPhotoSelectionButton(
                                    context: context,
                                    buttonText: 'Upload SSLC Certificate',
                                    compressedFile:
                                        controller.state.sslc_compressed,
                                    file: controller.state.sslc_path),
                                SizedBox(height: 30),
                                CheckboxMenuButton(
                                  style: ButtonStyle(
                                      alignment: AlignmentDirectional.topStart,
                                      elevation: MaterialStatePropertyAll(0),
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.transparent)),
                                  value: controller.state.isTermsAgreed.value,
                                  onChanged: (val) => controller
                                      .state.isTermsAgreed.value = val!,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    width: Get.width - 100,
                                    child: Text(
                                      'I here by solemnly declare that the above information provided by me are true and correct to the best of my knowledge and belief.lam fully aware of the course,syllabus,duration,training and validity of the certificate before getting in to admission. Further I will not raise any com plaints against the certification body about the validity of the merit certificate that I have completely understood.I shall obey the rules and regulations of study centre.Now in force and as amended or altered from time to time.I accept all decision of the TSSR council authorities in all matters of training.',
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                controller.state.isLoading.value
                                    ? SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(),
                                      )
                                    : ElevatedButton(
                                        onPressed: () async {
                                          await controller
                                              .manualDataSubmit(context);
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
                          child: SingleChildScrollView(
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
                                        'name',
                                        'dob',
                                        'age',
                                        'gender',
                                        'aadhaar',
                                        'parent_name',
                                        'district',
                                        'address',
                                        'pincode',
                                        'mobile_no',
                                        'email',
                                        'course',
                                        'date_of_admission',
                                        'course_batch'
                                      ],
                                          fileName: 'Student_Details_Skeleton',
                                          context: context),
                                  child: Text('Download '),
                                ),
                                SizedBox(height: 50),
                                Text(
                                  'Select the Excel file with .xlsx extension. The sheet should be properly structured accordingly. Use the above excel to upload the data.',
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
                                          await controller
                                              .selectAndUploadExcel(context);
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
                                SizedBox(height: 30),
                                CheckboxMenuButton(
                                  style: ButtonStyle(
                                      alignment: AlignmentDirectional.topStart,
                                      elevation: MaterialStatePropertyAll(0),
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.transparent)),
                                  value: controller.state.isTermsAgreed.value,
                                  onChanged: (val) => controller
                                      .state.isTermsAgreed.value = val!,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    width: Get.width - 100,
                                    child: Text(
                                      'I here by solemnly declare that the above information provided by me are true and correct to the best of my knowl- edge and belief.lam fully aware of the course,syllabus,duration,training and valid- ity of the certificate before getting in to admission. Further I will not raise any com- plaints against the certification body about the validity of the merit certificate that I have completely understood.I shall obey the rules and regulations of study centre.Now in force and as amended or altered from time to time.I accept all deci- sion of the TSSR council authorities in all matters of training.',
                                      overflow: TextOverflow.visible,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                ]),
              )
            ],
          );
        }));
  }

  Widget kPhotoSelectionButton(
      {required Rx<PlatformFile> file,
      required String buttonText,
      required BuildContext context,
      required Rx<Uint8List> compressedFile}) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            await controller.selectPhoto(
                file: file, fileBytes: compressedFile, context: context);
          },
          child: Text(buttonText),
        ),
        SizedBox(width: 10),
        Text(file.value.name.toString()),
      ],
    );
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
