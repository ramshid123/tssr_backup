import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSC/TSSC%20View/controller.dart';
import 'package:tssr_ctrl/pages/ADMIN/TSSR/TSSR%20View/tssrpage_index.dart';
import 'package:tssr_ctrl/pages/ADMIN/study_centre/franchise_view/franchisepage_index.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/widgets/tssr.dart';

Widget FranchiseCard(
    var data, FranchisePageController controller, BuildContext context) {
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
        await DatabaseService.FranchiseCollection.doc(data['doc_id']).delete();
        final deletedAccountId = await DatabaseService.DeletedAccounts.add(
            {'email': data['email'], 'password': data['password']});
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
                      await DatabaseService.FranchiseCollection.doc(
                              data['doc_id'])
                          .set({
                        'doc_id': data['doc_id'],
                        'courses': data['courses'],
                        'centre_name': data['centre_name'],
                        'centre_head': data['centre_head'],
                        'atc': data['atc'],
                        'district': data['district'],
                        'place': data['place'],
                        'renewal': data['renewal'],
                        'email': data['email'],
                        'password': data['password'],
                        'isAdmin': data['isAdmin'],
                        'uid': data['uid'],
                      }).then((value) => ScaffoldMessenger.of(context)
                              .hideCurrentSnackBar());
                      deletedAccountId.delete();
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
        final homectrl = FranchisePageController();
        await Get.bottomSheet(
          Container(
            padding: EdgeInsets.all(20),
            height: Get.height * 0.75,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Form(
                key: homectrl.state.editFormKey,
                child: Column(
                  children: [
                    EditBoxFormField('Centre Name', homectrl.state.centre_name,
                        data['centre_name']),
                    EditBoxFormField('Centre Head', homectrl.state.centre_head,
                        data['centre_head']),
                    EditBoxFormField(
                        'ATC Code', homectrl.state.atc, data['atc']),
                    EditBoxFormField(
                        'District', homectrl.state.district, data['district']),
                    EditBoxFormField(
                        'Place', homectrl.state.place, data['place']),
                    EditBoxFormField('Renewal Date', homectrl.state.renewal,
                        data['renewal']),
                    SizedBox(height: 20),
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
                              SizedBox(
                                height: ((Get.height - 200) / 2) - 73,
                                child: FirestoreListView(
                                    // loadingBuilder: (context) => FlutterLogo(),
                                    // emptyBuilder: (context) {
                                    //   print('no courses');
                                    //   return Center(
                                    //     child: Text(
                                    //       'No Courses',
                                    //       style: TextStyle(
                                    //           fontSize: 50, color: Colors.black),
                                    //     ),
                                    //   );
                                    // },
                                    query: DatabaseService.FranchiseCollection
                                        .where('atc', isEqualTo: data['atc']),
                                    emptyBuilder: (context) => Center(
                                          child: Text(
                                            'No Data',
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                    pageSize: 10,
                                    itemBuilder: (context, doc) =>
                                        ListView.builder(
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            final item =
                                                doc.data()['courses'][index];
                                            return ListTile(
                                              title: Text(item),
                                              trailing: IconButton(
                                                onPressed: () async =>
                                                    controller
                                                        .removeCourseFromList(
                                                            item,
                                                            doc.data()[
                                                                'doc_id']),
                                                icon: Icon(Icons.remove_circle),
                                              ),
                                            );
                                          },
                                          itemCount:
                                              doc.data()['courses'].length,
                                        )),
                              ),
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
                                  onFieldSubmitted: (val) => controller
                                      .searchCourseUsingGivenString(val),
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
                                                doc.data()['course'],
                                                ctrl,
                                                data['doc_id']),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.blachish_clr,
                        foregroundColor: Colors.white,
                        fixedSize: Size(200, 50),
                      ),
                      child: Text('Edit Courses'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (homectrl.state.editFormKey.currentState!
                            .validate()) {
                          try {
                            await DatabaseService.FranchiseCollection.doc(
                                    data['doc_id'])
                                .update({
                              'centre_name': homectrl.state.centre_name.text,
                              'centre_head': homectrl.state.centre_head.text,
                              'atc': homectrl.state.atc.text,
                              'district': homectrl.state.district.text,
                              'place': homectrl.state.place.text,
                              'renewal': homectrl.state.renewal.text,
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
        return data['isAdmin'] == 'false' ? true : false;
      }
    },
    direction: data['isAdmin'] == 'false'
        ? DismissDirection.horizontal
        : DismissDirection.endToStart,
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
                    data['centre_name'],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  Text(data['atc'], style: TextStyle(fontSize: 18)),
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
                                BottomSheetItem(
                                    'Center Name', data['centre_name']),
                                BottomSheetItem(
                                    'Centre Head', data['centre_head']),
                                BottomSheetItem('ATC', data['atc']),
                                BottomSheetItem('Email', data['email']),
                                BottomSheetItem('Password', data['password']),
                                BottomSheetItem('District', data['district']),
                                BottomSheetItem('Place', data['place']),
                                BottomSheetItem('Renewal', data['renewal']),
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
              FranchiseCardItem('Centre Head', data['centre_head'], 0),
              FranchiseCardItem('District', data['district'], 1),
              FranchiseCardItem('Renewal', data['renewal'], 0),
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

Widget FranchiseCardItem(String title, String info, int index) {
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

Widget EditCourseItem(String title) {
  return ListTile(
    title: Text(title),
    trailing: IconButton(
      onPressed: () {},
      icon: Icon(Icons.remove_circle),
    ),
  );
}

Widget KCourseListViewItem(
    String title, FranchisePageController controller, String doc_id) {
  return ListTile(
    title: Text(title),
    trailing: IconButton(
      onPressed: () async => controller.addCourseToList(title, doc_id),
      icon: Icon(Icons.add_circle),
    ),
  );
}
