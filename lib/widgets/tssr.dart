import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR%20Page/tssrpage_index.dart';

Widget TssrCard(var data,  controller) {
  final key = GlobalKey();
  return Dismissible(
    key: key,
    background: Container(
      color: Colors.red,
      child: Row(
        children: [
          Icon(
            Icons.delete,
            size: 100,
            color: Colors.white,
          ),
          Spacer(),
        ],
      ),
    ),
    onDismissed: (val) {
      controller.deleteFromList(data);
    },
    direction: DismissDirection.startToEnd,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: Get.width,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            spreadRadius: 1,
            blurRadius: 5,
            color: Colors.grey,
            offset: Offset(0, 1))
      ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  Text(data['reg_no'], style: TextStyle(fontSize: 18)),
                ],
              ),
              Row(
                children: [
                  Text(data['result'],
                      style: TextStyle(
                          fontSize: 18,
                          color: data['result'].toString().toLowerCase().contains('pass')
                              ? Colors.green
                              : Colors.red)),
                  IconButton(
                    onPressed: () {
                      Get.bottomSheet(
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))),
                          child: Stack(
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(height: 30),
                                    Text(
                                      'Student details',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    BottomSheetItem('Name', data['name']),
                                    BottomSheetItem(
                                        'Register No', data['reg_no']),
                                    BottomSheetItem('Result', data['result']),
                                    BottomSheetItem('Course', data['course']),
                                    BottomSheetItem('Duration', data['duration']),
                                    BottomSheetItem(
                                        'Study Centre', data['study_centre']),
                                    BottomSheetItem(
                                        'Exam Data', data['exam_date']),
                                    BottomSheetItem('Grade', data['grade']),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 20,
                                child: IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: Icon((Icons.clear))),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.navigate_next),
                  ),
                ],
              ),
            ],
          ),
          Divider(),
          Column(
            children: [
              TssrCardItem('Course', data['course'], 0),
              TssrCardItem('Study Centre', data['study_centre'], 1),
              TssrCardItem('Exam Date', data['exam_date'], 0),
              TssrCardItem('Grade', data['grade'], 1),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    ),
  );
}

Widget CustomTextForm({
  BuildContext? context,
  required String hintText,
  required TextEditingController ctrl,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        hintText,
        style: TextStyle(
            fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.deepPurple[100],
            hintText: hintText,
            enabled: true,
            focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: ColorConstants.greenish_clr, width: 2)),
            enabledBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: ColorConstants.purple_clr, width: 2)),
            suffixIcon: hintText.toLowerCase().contains('date')
                ? IconButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context!,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2001),
                        lastDate: DateTime(2050),
                      );
                      if (date != null) {
                        ctrl.text =
                            '${DateFormat.d().format(date)}/${DateFormat.M().format(date)}/${DateFormat.y().format(date)}';
                      }
                    },
                    icon: Icon(Icons.date_range),
                  )
                : null),
        readOnly: hintText.toLowerCase().contains('date') ? true : false,
        validator: (val) {
          if (val!.isEmpty) return 'Required';

          return null;
        },
      ),
    ],
  );
}

Widget BottomSheetItem(String title, String info) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 10),
      Text(
        title,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey),
      ),
      SizedBox(height: 5),
      Text(
        info,
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
      ),
      Divider(),
      SizedBox(height: 10),
    ],
  );
}

Widget TssrCardItem(String title, String info, int index) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    margin: EdgeInsets.all(2),
    decoration: BoxDecoration(
        color: index.isEven ? Colors.grey[300] : Colors.transparent,
        borderRadius: BorderRadius.circular(10)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18)),
        SizedBox(width: 20),
        Expanded(
            child: Text(info,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end)),
      ],
    ),
  );
}
