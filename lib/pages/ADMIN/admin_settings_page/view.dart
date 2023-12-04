import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tssr_ctrl/constants/colors.dart';
import 'package:tssr_ctrl/services/database_service.dart';
import 'package:tssr_ctrl/widgets/app_bar.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Access Settings'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = Get.width <= 768 ? true : false;
          return SizedBox(
            height: Get.height,
            width: Get.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 60),
                  Text(
                    'Access Settings Services',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 1,
                    width: 100,
                    color: ColorConstants.blachish_clr,
                  ),
                  SizedBox(height: 30),
                  FirestoreListView(
                      shrinkWrap: true,
                      query: DatabaseService.MetaInformations,
                      itemBuilder: (context, doc) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 20 : 0),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            runSpacing: 20,
                            spacing: 20,
                            children: [
                              adminSwitchContainer(
                                isMobile: isMobile,
                                title: 'Access to Reports',
                                subtitle:
                                    'Allow or deny the access to every client\'s reports section.',
                                value: doc.data()['can_access_reports'],
                                firestoreDocId: doc.id,
                                fieldId: 'can_access_reports',
                              ),
                              adminSwitchContainer(
                                isMobile: isMobile,
                                title: 'Permit Admission',
                                subtitle:
                                    'Allow or deny the new admission registrations of every clients.',
                                value: doc.data()['permit_admissions'],
                                firestoreDocId: doc.id,
                                fieldId: 'permit_admissions',
                              ),
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget adminSwitchContainer(
    {required bool isMobile,
    required String title,
    required String subtitle,
    required String firestoreDocId,
    required String fieldId,
    required bool value}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    width: isMobile ? Get.width : Get.width / 3,
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(0.3),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(subtitle),
            ],
          ),
        ),
        SizedBox(width: 10),
        Container(
          height: 50,
          width: 1,
          color: ColorConstants.blachish_clr,
        ),
        SizedBox(width: 10),
        Switch(
          value: value,
          onChanged: (val) async {
            await DatabaseService.MetaInformations.doc(firestoreDocId).update({
              fieldId: value = val,
            });
          },
        ),
      ],
    ),
  );
}
