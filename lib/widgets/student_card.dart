import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:tssr_ctrl/pages/FRANCHISE/student_view/sslc_view.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/services/storage_service.dart';

Widget StudentCard(var data, controller, BuildContext context) {
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
    onDismissed: (val) async {
      try {
        await DatabaseService.StudentDetailsCollection.doc(data['doc_id'])
            .delete();
        var isDeleteConfirm = true;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            duration: 10.seconds,
            content: GestureDetector(
              onTap: () async {
                await DatabaseService.StudentDetailsCollection.doc(
                        data['doc_id'])
                    .set({
                  'doc_id': data['doc_id'],
                  'course': data['course'],
                  'date_of_admission': data['date_of_admission'],
                  'date_of_course_start': data['date_of_course_start'],
                  'district': data['district'],
                  'parent_name': data['parent_name'],
                  'photo_url': data['photo_url'],
                  'place': data['place'],
                  'reg_no': data['reg_no'],
                  'sslc_url': data['sslc_url'],
                  'st_aadhaar': data['st_aadhaar'],
                  'st_address': data['st_address'],
                  'st_age': data['st_age'],
                  'st_district': data['st_district'],
                  'st_dob': data['st_dob'],
                  'st_email': data['st_email'],
                  'st_gender': data['st_gender'],
                  'st_mobile_no': data['st_mobile_no'],
                  'st_name': data['st_name'],
                  'st_pincode': data['st_pincode'],
                  'study_centre': data['study_centre'],
                  'uploader': data['uploader'],
                }).then((value) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  isDeleteConfirm = false;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Undo the delete',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Icon(Icons.undo, color: Colors.white).paddingAll(10),
                ],
              ),
            ),
          ),
        );
        await Future.delayed(10.seconds);
        if (isDeleteConfirm) {
          await StorageService().instance.refFromURL(data['sslc_url']).delete();
          await StorageService()
              .instance
              .refFromURL(data['photo_url'])
              .delete();
        }
      } catch (e) {
        print(e);
      }
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
                    data['st_name'],
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
                                data['photo_url'] != 'none'
                                    ? Image.network(
                                        data['photo_url'],
                                        width: 200,
                                        fit: BoxFit.contain,
                                      )
                                    : ElevatedButton(
                                        onPressed: () async => await controller
                                            .selectAndUploadPhoto(
                                          reg_no: data['reg_no'],
                                          doc_id: data['doc_id'],
                                          type: 'Photo',
                                        ),
                                        child: Text('Upload Photo'),
                                      ),
                                SizedBox(height: 10),
                                data['sslc_url'] != 'none'
                                    ? ElevatedButton(
                                        onPressed: () async => await Get.to(
                                            SSLCPage(
                                                imageUrl: data['sslc_url'])),
                                        child: Text('View SSLC'))
                                    : ElevatedButton(
                                        onPressed: () async => await controller
                                                .selectAndUploadPhoto(
                                              reg_no: data['reg_no'],
                                              doc_id: data['doc_id'],
                                              type: 'SSLC',
                                            ),
                                        child: Text('Upload SSLC photo')),
                                SizedBox(height: 10),
                                BottomSheetItem('Name', data['st_name']),
                                BottomSheetItem('Register No', data['reg_no']),
                                BottomSheetItem('DoB', data['st_dob']),
                                BottomSheetItem(
                                    'Parent name', data['parent_name']),
                                BottomSheetItem('Age', data['st_age']),
                                BottomSheetItem('Gender', data['st_gender']),
                                BottomSheetItem('Aadhaar', data['st_aadhaar']),
                                BottomSheetItem(
                                    'District', data['st_district']),
                                BottomSheetItem('Pincode', data['st_pincode']),
                                BottomSheetItem(
                                    'Mobile No', data['st_mobile_no']),
                                BottomSheetItem('Email', data['st_email']),
                                BottomSheetItem('Course', data['course']),
                                BottomSheetItem('Date of admission',
                                    data['date_of_admission']),
                                BottomSheetItem('Course batch',
                                    data['date_of_course_start']),
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
              StudentCardItem('Course', data['course'], 0),
              StudentCardItem('DoB', data['st_dob'], 1),
              StudentCardItem('Gender', data['st_gender'], 0),
              StudentCardItem('Aadhaar', data['st_aadhaar'], 1),
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

Widget StudentCardItem(String title, String info, int index) {
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
