import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR/result View/resultview_index.dart';
import 'package:tssr_ctrl/services/database_service.dart';

Widget ResultCard(var data, controller, BuildContext context) {
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
    secondaryBackground: Container(
      color: Colors.blue,
      child: Row(
        children: [
          Spacer(),
          Icon(
            Icons.edit,
            size: 100,
            color: Colors.white,
          ),
        ],
      ),
    ),
    onDismissed: (val) async {
      try {
        await DatabaseService.ResultCollection.doc(data['doc_id']).delete();
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: 10.seconds,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Undo the delete',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                IconButton(
                    color: Colors.white,
                    onPressed: () async {
                      await DatabaseService.ResultCollection.doc(data['doc_id'])
                          .set({
                        'doc_id': data['doc_id'],
                        'name': data['name'],
                        'reg_no': data['reg_no'],
                        'result': data['result'],
                        'course': data['course'],
                        'duration': data['duration'],
                        'study_centre': data['study_centre'],
                        'exam_centre': data['exam_centre'],
                        'exam_date': data['exam_date'],
                        'grade': data['grade'],
                      }).then((value) => ScaffoldMessenger.of(context)
                              .hideCurrentSnackBar());
                    },
                    icon: Icon(Icons.undo))
              ],
            ),
          ),
        );
      } catch (e) {
        print(e);
      }
    },
    confirmDismiss: (direction) async {
      if (direction == DismissDirection.endToStart) {
        final homectrl = ResultViewController();
        await Get.bottomSheet(
          Container(
            padding: EdgeInsets.all(20),
            height: Get.height * 0.75,
            color: Color.fromRGBO(255, 255, 255, 1),
            child: SingleChildScrollView(
              child: Form(
                key: homectrl.state.editFormKey,
                child: Column(
                  children: [
                    EditBoxFormField('Name', homectrl.state.name, data['name']),
                    EditBoxFormField(
                        'Register No', homectrl.state.reg_no, data['reg_no']),
                    EditBoxFormField(
                        'Result', homectrl.state.result, data['result']),
                    EditBoxFormField(
                        'Course', homectrl.state.course, data['course']),
                    EditBoxFormField(
                        'Duration', homectrl.state.duration, data['duration']),
                    EditBoxFormField('Study Centre',
                        homectrl.state.study_centre, data['study_centre']),
                    EditBoxFormField('Exam Centre', homectrl.state.exam_centre,
                        data['exam_centre']),
                    EditBoxFormField('Exam Date', homectrl.state.exam_date,
                        data['exam_date']),
                    EditBoxFormField(
                        'Grade', homectrl.state.grade, data['grade']),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (homectrl.state.editFormKey.currentState!
                            .validate()) {
                          try {
                            await DatabaseService.ResultCollection.doc(
                                    data['doc_id'])
                                .update({
                              'name': homectrl.state.name.text,
                              'reg_no': homectrl.state.reg_no.text,
                              'result': homectrl.state.result.text,
                              'course': homectrl.state.course.text,
                              'duration': homectrl.state.duration.text,
                              'study_centre': homectrl.state.study_centre.text,
                              'exam_centre': homectrl.state.exam_centre.text,
                              'exam_date': homectrl.state.exam_date.text,
                              'grade': homectrl.state.grade.text,
                            }).then((value) => Navigator.of(context).pop());
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(Get.width, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        return false;
      } else {
        return true;
      }
    },
    direction: DismissDirection.horizontal,
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
                          color: data['result']
                                  .toString()
                                  .toLowerCase()
                                  .contains('pass')
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
                                    BottomSheetItem(
                                        'Duration', data['duration']),
                                    BottomSheetItem(
                                        'Study Centre', data['study_centre']),
                                    BottomSheetItem(
                                        'Exam Centre', data['exam_centre']),
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
              ResultCardItem('Course', data['course'], 0),
              ResultCardItem('Study Centre', data['study_centre'], 1),
              ResultCardItem('Exam Date', data['exam_date'], 0),
              ResultCardItem('Grade', data['grade'], 1),
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

Widget ResultCardItem(String title, String info, int index) {
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

Widget EditBoxFormField(String hint, TextEditingController ctrl, String value) {
  ctrl.text = value;
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 20),
      Text(
        hint,
        style: TextStyle(
          fontSize: 20,
          color: Colors.grey[600],
        ),
      ),
      SizedBox(height: 5),
      TextFormField(
        controller: ctrl,
        decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: hint.toLowerCase().contains('date')
                ? Builder(builder: (context) {
                    return IconButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
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
                    );
                  })
                : null),
        readOnly: hint.toLowerCase().contains('date') ? true : false,
        validator: (val) {
          return val == null || val.isEmpty ? 'Reqired' : null;
        },
      ),
    ],
  );
}
