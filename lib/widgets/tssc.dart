import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSC/TSSC%20View/controller.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR/TSSR%20View/tssrpage_index.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/widgets/tssr.dart';

Widget TsscCard(var data, TsscPageController controller, BuildContext context) {
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
        await DatabaseService.tsscCollection.doc(data['doc_id']).delete();
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
                      await DatabaseService.tsscCollection
                          .doc(data['doc_id'])
                          .set({
                        'doc_id': data['doc_id'],
                        'name': data['name'],
                        'reg_no': data['reg_no'],
                        'skill': data['skill'],
                        'skill_centre': data['skill_centre'],
                        'exam_date': data['exam_date'],
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
        final homectrl = TsscPageController();
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
                        'Skill', homectrl.state.skill, data['skill']),
                    EditBoxFormField('Skill Centre',
                        homectrl.state.skill_centre, data['skill_centre']),
                    EditBoxFormField('Exam Date', homectrl.state.exam_date,
                        data['exam_date']),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (homectrl.state.editFormKey.currentState!
                            .validate()) {
                          try {
                            await DatabaseService.tsscCollection
                                .doc(data['doc_id'])
                                .update({
                              'name': homectrl.state.name.text,
                              'reg_no': homectrl.state.reg_no.text,
                              'skill': homectrl.state.skill.text,
                              'skill_centre': homectrl.state.skill_centre.text,
                              'exam_date': homectrl.state.exam_date.text,
                            }).then((value) => Navigator.of(context).pop());
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(Get.width, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
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
                                BottomSheetItem('Register No', data['reg_no']),
                                BottomSheetItem('Skill', data['skill']),
                                BottomSheetItem(
                                    'Skill Centre', data['skill_centre']),
                                BottomSheetItem('Exam Date', data['exam_date']),
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
          Divider(),
          Column(
            children: [
              TsscCardItem('Skill Centre', data['skill_centre'], 0),
              TsscCardItem('Skill', data['skill'], 1),
              TsscCardItem('Exam Date', data['exam_date'], 0),
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
          if (val!.isEmpty)
            return 'Required';
          else if (hintText.toLowerCase().contains('email') &&
              !GetUtils.isEmail(val))
            return 'Invalid Email Format';
          else if (hintText.toLowerCase().contains('password') &&
              val.length < 6) return 'Must be atleast 6 charecters';

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

Widget TsscCardItem(String title, String info, int index) {
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
